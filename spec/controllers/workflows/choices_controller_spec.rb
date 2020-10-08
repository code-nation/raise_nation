require 'rails_helper'

RSpec.describe Workflows::ChoicesController, type: :controller do
  let(:user) { create(:user, :with_all) }
  let(:account) { user.accounts.first }

  before { sign_in user }

  describe 'GET index (Nation to Raisely - source)' do
    let!(:nation1) { create(:nation, slug: 'Test Nation', account: account) }
    let!(:raisely1) { create(:raisely_campaign, name: 'Test Raisely', account: account) }
    let(:workflow_type) { 'nr' }
    let(:kind) { 'source' }
    let(:q) { 'Test' }

    before(:each) do
      get :index, params: { workflow_type: workflow_type, kind: kind, q: q }
    end

    it 'should respond with correct results' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json['results'][0]['text']).to eq nation1.slug
      expect(json['results'][0]['id']).to eq nation1.id
    end

    context 'kind is target' do
      let(:kind) { 'target' }

      it 'should respond with correct results' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json['results'][0]['text']).to eq raisely1.name
        expect(json['results'][0]['id']).to eq raisely1.id
      end
    end

    context 'workflow type is rn' do
      let(:workflow_type) { 'rn' }

      it 'should respond with correct results' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json['results'][0]['text']).to eq raisely1.name
        expect(json['results'][0]['id']).to eq raisely1.id
      end

      context 'kind is target' do
        let(:kind) { 'target' }

        it 'should respond with correct results' do
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(json['results'][0]['text']).to eq nation1.slug
          expect(json['results'][0]['id']).to eq nation1.id
        end
      end
    end

    context 'missing query' do
      let(:q) { 'Not existing' }

      it 'should respond with correct results' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json['results']).to be_blank
      end
    end
  end
end
