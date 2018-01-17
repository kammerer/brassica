class LinkageMap < ActiveRecord::Base
  belongs_to :plant_population, counter_cache: true, touch: true
  belongs_to :user

  after_update { map_locus_hits.each(&:touch) }
  after_update { linkage_groups.each(&:touch) }
  before_destroy { map_locus_hits.each(&:touch) }
  before_destroy { linkage_groups.each(&:touch) }

  has_many :linkage_groups
  has_many :genotype_matrices
  has_many :map_locus_hits
  has_many :qtl_jobs

  validates :linkage_map_label,
            presence: true,
            uniqueness: true

  validates :linkage_map_name,
            presence: true

  validates :map_version_no,
            presence: true,
            length: { minimum: 1, maximum: 3 }

  default_scope { includes(plant_population: :taxonomy_term) }

  include Searchable
  include Publishable

  def self.indexed_json_structure
    {
      only: [
        :linkage_map_label,
        :linkage_map_name,
        :map_version_no,
        :map_version_date
      ],
      include: {
        plant_population: {
          only: [:name],
          include: { taxonomy_term: { only: [:name] } }
        }
      }
    }
  end
end
