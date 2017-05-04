class AnalysesController < ApplicationController
  before_filter :authenticate_user!, if: :require_user?

  def index
    @analyses = current_user.analyses.recent_first
  end

  def new
    if params.key?(:analysis)
      @analysis = Analysis.new(analysis_params)
      @form = form
    end
  end

  def create
    @form = form

    if @form.valid?
      @form.save do |attrs|
        attrs = attrs.merge(owner: current_user).
          except(:genotype_data_file_id, :phenotype_data_file_id, :map_data_file_id)

        analysis = Analysis.create!(attrs)
        analysis.data_files << @form.genotype_data_file
        analysis.data_files << @form.map_data_file if @form.map_data_file
        analysis.data_files << @form.phenotype_data_file unless @form.plan_trial_based?

        AnalysisJob.new(analysis).enqueue
      end

      redirect_to analyses_path, notice: "New analysis started"
    else
      @analysis = Analysis.new(analysis_params)

      render :new
    end
  end

  def show
    @analysis = current_user.analyses.find(params[:id])

    respond_to do |format|
      format.json { render json: @analysis }
      format.html do
        if request.xhr?
          render partial: "analysis_item", layout: false, locals: { analysis: @analysis }
        elsif @analysis.gwas?
          @manhattan = Analysis::Gwas::ManhattanPlot.new(@analysis).call
        end
      end
    end
  end

  def destroy
    analysis = current_user.analyses.finished.find(params[:id])
    analysis.destroy

    redirect_to analyses_path, notice: "Analysis '#{analysis.name}' deleted"
  end

  private

  def require_user?
    action_name != "new" || params[:analysis].present?
  end

  def analysis_params
    params.require(:analysis).permit(:analysis_type)
  end

  def form_params
    params.require(:analysis).permit(*form_klass.permitted_properties)
  end

  def form
    form_klass.new(Hashie::Mash.new(form_params))
  end

  def form_klass
    Analyses::Gwas::Form
  end
end
