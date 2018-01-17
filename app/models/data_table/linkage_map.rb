class DataTable::LinkageMap < DataTable::Base
  self.table_name = "data_table_linkage_maps"

  include Filterable
  include Pluckable
  include TableData

  def self.permitted_params
    [
      :fetch,
      query: params_for_filter(table_columns) +
        [
          'plant_populations.id',
          'linkage_groups.id',
          'user_id',
          'id'
        ]
    ]
  end

  def self.table_columns
    [
      'taxonomy_terms.name',
      'plant_populations.name',
      'linkage_map_label',
      'linkage_map_name',
      'map_version_no',
      'map_version_date'
    ]
  end

  def self.count_columns
    [
      'linkage_groups_count',
      'map_locus_hits_count'
    ]
  end

  def self.ref_columns
    [
      'plant_population_id',
      'pubmed_id'
    ]
  end

  include Annotable
end
