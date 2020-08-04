require 'rails_helper'

RSpec.describe 'Add nation under an account', type: :system do
  let!(:user) { create(:user, :with_accounts) }
  let!(:account) { user.accounts.first }
  let(:slug) { Faker::Company.name.downcase.underscore }
  let(:auth_url) { '/accounts/nations/oauth?code=1234&nation_id=1' }
  let(:auth_code) do
    OpenStruct.new(
      {
        authorize_url: ''
      }
    )
  end
  let(:auth_client) do
    OpenStruct.new(
      {
        auth_code: auth_code
      }
    )
  end
  let(:nb_api_token) { SecureRandom.uuid }

  before(:each) do
    allow_any_instance_of(Nation).to receive(:nb_auth_client).and_return(auth_client)
    allow_any_instance_of(Nation).to receive(:nb_api_token).and_return(nb_api_token)
    allow(auth_code).to receive(:authorize_url).and_return(auth_url)

    login_as(user, scope: :user)
  end

  it 'should add nation', js: true do
    visit "/accounts/#{account.id}"

    expect(page).to have_content('Add Nation')

    within('div.nation-listing-controls') do
      find('a.add-nation').click
    end

    within('div.modal-dialog') do
      expect(page).to have_content('Add Nation')
      find('input#nation_slug').set(slug)
      find('input.add-nation-submit').click
    end

    expect(page).to have_content('Your nation was connected successfully')
  end

  describe 'Existing slug' do
    let!(:nation) { create(:nation, slug: slug) }

    it 'should not add nation', js: true do
      visit "/accounts/#{account.id}"

      expect(page).to have_content('Add Nation')

      within('div.nation-listing-controls') do
        find('a.add-nation').click
      end

      within('div.modal-dialog') do
        expect(page).to have_content('Add Nation')
        find('input#nation_slug').set(slug)
        find('input.add-nation-submit').click
      end

      expect(page).not_to have_content('Your nation was connected successfully')
      expect(page).to have_content('Slug has already been taken')
    end
  end
end
