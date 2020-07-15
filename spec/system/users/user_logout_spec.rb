require 'rails_helper'

RSpec.describe 'User Logout', type: :system, js: true do
  let!(:user) { create(:user, password: password) }
  let!(:password) { 'P@ssw0rd!' }
  before(:each) { login_as(user, scope: :user) }

  it 'Logout successfully' do
    visit '/'

    expect(page).to have_content("Create new account")
    expect(page.current_path).to eq "/accounts/new"

    within "li.user-profile" do
      find("a.nav-link").click

      within '.dropdown-menu' do
        find('a.user-logout').click
      end
    end

    within ".modal-content" do
      find("a.btn-primary").click
    end

    expect(page.current_path).to eq '/users/sign_in'
  end
end
