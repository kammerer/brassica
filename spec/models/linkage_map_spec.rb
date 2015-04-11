require 'rails_helper'

RSpec.describe LinkageMap do
  describe '#table_data' do
    it 'gets proper columns' do
      lm = create(:linkage_map)
      table_data = LinkageMap.table_data
      expect(table_data.count).to eq 1
      expect(table_data[0]).to eq [
        lm.plant_population.taxonomy_term.name,
        lm.linkage_map_label,
        lm.linkage_map_name,
        lm.plant_population.name,
        lm.map_version_no,
        lm.map_version_date,
        lm.id
      ]
    end
  end
end
