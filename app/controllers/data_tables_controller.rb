class DataTablesController < ApplicationController
  helper_method :model_klass

  def index
    respond_to do |format|
      format.html do
        double_reference_adjustment
        model_param
      end
      format.json do
        cache_key = params.reject{ |k,_| %w(_ controller action format).include? k }
        cache_key[:latest_change] = model_klass.maximum('updated_at')
        cache_key[:count] = model_klass.count
        cache_key[:user_id] = current_user.try(:id)
        logger.info "CACHE KEY: #{cache_key}"
        grid_data = Rails.cache.fetch(cache_key, expires_in: 300.days) do
          logger.info 'MISS MISS MISS'
          prepare_grid_data.to_json
        end
        # grid_data = prepare_grid_data.to_json # TODO: Remove before flight
        render json: grid_data
      end
    end
  end

  def show
    object = model_klass.find(params[:id])
    render json: object.annotations_as_json
  end

  private

  def prepare_grid_data
    objects = model_klass.table_data(params, current_user.try(:id))
    ApplicationDecorator.decorate(objects).as_grid_data
  end

  def model_param
    if params[:model].present? && !allowed_models.include?(params[:model])
      raise ActionController::RoutingError.new('Not Found')
    end
    params.require(:model)
  end

  def model_klass
    if model_param == "linkage_maps"
      DataTable::LinkageMap
    else
      model_param.singularize.camelize.constantize
    end
  end

  def allowed_models
    [
      'linkage_groups',
      'linkage_maps',
      'map_locus_hits',
      'map_positions',
      'marker_assays',
      'plant_accessions',
      'plant_lines',
      'plant_populations',
      'plant_scoring_units',
      'plant_trials',
      'plant_varieties',
      'population_loci',
      'primers',
      'probes',
      'qtl',
      'qtl_jobs',
      'trait_descriptors',
      'trait_scores'
    ]
  end

  def double_reference_adjustment
    ['_a', '_b'].each do |suffix|
      if params[:model].present? && params[:model].end_with?(suffix)
        params[:model] = params[:model][0..-3]
        if params[:query].present? && params[:query]['primers.id'].present?
          params[:query] = { "primer#{suffix}_id" => params[:query]['primers.id'] }
        end
      end
    end
  end
end
