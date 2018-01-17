class DataTable::LinkageMap < DataTable::Base
  self.table_name = "data_table_linkage_maps"

  # NOTES:
  #
  # --- 1. visibility of related records - handled by Relatable concern (which relies on associations)
  # 2. visibility of joined records - todo (possible not handled at all; perhaps submissions does not allow for it)
  # 3. filtering by foreign key, e.g. plant_populations.id (param handling) - todo (old urls need to work, so param aliasing is needed)
  # 4. i18n of table headers - todo (simple addition to locales)

  has_many :linkage_groups
  has_many :map_locus_hits

  include Visible
  include Relatable

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
      'taxonomy_term_name',
      'plant_population_name',
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
