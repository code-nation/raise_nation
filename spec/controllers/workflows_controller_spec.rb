require 'rails_helper'

RSpec.describe WorkflowsController, type: :controller do
  let(:user) { create(:user, :with_all) }
  let(:account) { user.accounts.first }

  before { sign_in user }

  describe 'GET index' do
    let!(:workflow1) { create(:workflow, account: account) }
    let!(:workflow2) { create(:workflow, account: account) }
    let!(:workflow3) { create(:workflow, account: account) }
    let!(:workflow4) { create(:workflow) }

    before(:each) do
      get :index
    end

    it 'should respond successfully' do
      expect(response).to have_http_status(:ok)
      expect(assigns(:workflows)).to include(workflow1)
      expect(assigns(:workflows)).to include(workflow2)
      expect(assigns(:workflows)).to include(workflow3)
      expect(assigns(:workflows)).not_to include(workflow4)
    end
  end
end
