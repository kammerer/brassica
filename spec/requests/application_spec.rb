require 'rails_helper'

RSpec.describe 'Application index' do
  describe 'GET /' do
    it 'shows no submission if none are finalized' do
      get '/'
      expect(response).to have_http_status(:success)
      expect(response).not_to render_template('submissions/_submissions_list')
    end

    it 'shows all submissions if less then 5 are finalized' do
      create_list(:submission, 2, finalized: true)
      create_list(:submission, 1, finalized: false)
      get '/'
      expect(response).to have_http_status(:success)
      expect(response).to render_template('submissions/_submissions_list')
      expect(response.body).to include 'Latest submissions'
      expect(response.body.scan('Submitted on').size).to eq 2
    end

    it 'shows at most 5 finalized submissions' do
      create_list(:submission, 7, finalized: true)
      get '/'
      expect(response).to have_http_status(:success)
      expect(response.body.scan('Submitted on').size).to eq 5
    end
  end
end