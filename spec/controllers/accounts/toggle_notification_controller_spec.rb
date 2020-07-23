require 'rails_helper'

RSpec.describe Accounts::ToggleNotificationController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'PUT update' do
  end
end
