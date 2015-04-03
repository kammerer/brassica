class DataTablesController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        render "#{model_param.tableize}_table"
      end
      format.json do
        objects = model_param.singularize.camelize.constantize.table_data(params)
        grid_data = ApplicationDecorator.decorate(objects)
        render json: grid_data.as_grid_data
      end
    end
  end

  private

  def model_param
    if params[:model].present? && !allowed_models.include?(params[:model])
      raise ActionController::RoutingError.new('Not Found')
    end
    params.require(:model)
  end

  def allowed_models
    %w(plant_trials trait_descriptors plant_lines plant_populations)
  end
end