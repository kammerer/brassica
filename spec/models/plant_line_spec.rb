require 'rails_helper'

RSpec.describe PlantLine do
  describe '#grid_data' do
    it 'returns empty result when no plant lines found' do
      expect(PlantLine.grid_data(plant_line_names: [1])).to be_empty
    end

    it 'orders populations by common name' do
      plids = create_list(:plant_line, 3).map(&:plant_line_name)
      gd = PlantLine.grid_data(query: { plant_line_name: plids })
      expect(gd.map(&:first)).to eq plids.sort
    end

    it 'gets proper columns' do
      tt = create(:taxonomy_term, name: 'tt')
      de = Date.today
      pl = create(:plant_line,
                   taxonomy_term: tt,
                   common_name: 'cn',
                   previous_line_name: 'pln',
                   date_entered: de,
                   data_owned_by: 'dob',
                   organisation: 'o')

      gd = PlantLine.grid_data(
        query: { plant_line_name: [pl.plant_line_name] }
      )
      expect(gd.count).to eq 1
      expect(gd[0][1..-1]).to eq %w(tt cn pln) + [de] + %w(dob o)
    end

    it 'supports multi-criteria queries' do
      pl = create(:plant_line, common_name: 'cn', organisation: 'o')
      create(:plant_line, common_name: 'cn', organisation: 'x')
      create(:plant_line, common_name: 'nc', organisation: 'o')
      gd = PlantLine.grid_data(
        query: {
          common_name: 'cn',
          organisation: 'o'
        }
      )
      expect(gd.count).to eq 1
      expect(gd[0][0]).to eq pl.plant_line_name
    end

    it 'supports querying by associated objects' do
      pending('This waits till #37 fix')
      fail
    end
  end
end
