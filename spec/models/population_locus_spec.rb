require 'rails_helper'

RSpec.describe PopulationLocus do
  describe '#filter' do
    it 'will query by permitted params' do
      pls = create_list(:population_locus, 2)
      filtered = PopulationLocus.filter(
        query: { 'plant_populations.id' => pls[0].plant_population.id }
      )
      expect(filtered.count).to eq 1
      expect(filtered.first).to eq pls[0]
      filtered = PopulationLocus.filter(
        query: { 'marker_assays.id' => pls[0].marker_assay.id }
      )
      expect(filtered.count).to eq 1
      expect(filtered.first).to eq pls[0]
      filtered = PopulationLocus.filter(
        query: { 'id' => pls[0].id }
      )
      expect(filtered.count).to eq 1
      expect(filtered.first).to eq pls[0]
    end
  end

  describe '#table_data' do
    it 'gets proper data table columns' do
      pl = create(:population_locus)
      create_list(:map_position, 3, population_locus: pl)
      create_list(:map_locus_hit, 2, population_locus: pl)

      table_data = PopulationLocus.table_data
      expect(table_data.count).to eq 1
      expect(table_data[0]).to eq [
        pl.plant_population.name,
        pl.marker_assay.marker_assay_name,
        pl.mapping_locus,
        pl.defined_by_whom,
        3, 2,
        pl.plant_population.id,
        pl.marker_assay.id,
        pl.id
      ]
    end
  end
end
