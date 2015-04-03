class PlantTrial < ActiveRecord::Base

  has_many :plant_scoring_units
  has_many :processed_trait_datasets
  belongs_to :plant_population
  belongs_to :country

  include Filterable
  include Pluckable

  def self.table_data(params = nil)
    query = (params && params[:query].present?) ? filter(params) : all
    query.order(:trial_year).pluck_columns(table_columns)
  end

  def self.table_columns
    [
      'plant_trial_name',
      'plant_trial_description',
      'project_descriptor',
      'plant_populations.name',
      'trial_year',
      'trial_location_site_name',
      'date_entered'
    ]
  end

  private

  def self.permitted_params
    [
      query: [
        :project_descriptor
      ]
    ]
  end
end
