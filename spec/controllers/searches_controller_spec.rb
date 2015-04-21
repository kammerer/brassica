require 'rails_helper'

RSpec.describe SearchesController do
  describe "GET :new" do
    let(:search) { instance_double("Search") }
    let(:search_results) { { plant_lines: 7, plant_populations: 135 } }

    it "returns counts of found records" do
      expect(Search).to receive(:new).with("foo").and_return(search)
      expect(search).to receive(:counts).and_return(search_results)

      get :new, search: "foo"

      expect(response).to be_success
      results = JSON.parse(response.body)
      expect(results).to match_array [
        { 'model' => 'plant_line', 'count' => 7, 'message' => 'Found 7 plant lines' },
        { 'model' => 'plant_population', 'count' => 135, 'message' => 'Found 135 plant populations' }
      ]
    end
  end
end
