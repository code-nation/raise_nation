require 'rails_helper'

RSpec.describe InvitationMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:inviter_name) { 'Test Name' }
  let(:org_name) { Faker::Company.name }

  describe 'account_user_invitation' do
    let(:mail) do
      InvitationMailer.account_user_invitation(
        user: user,
        inviter_name: inviter_name,
        org_name: org_name
      )
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('You got an invitation to a RaiseNation account')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(
        /You have been added by #{inviter_name} to collaborate in the RaiseNation account for #{ERB::Util.html_escape(org_name)}/
      )
      expect(mail.body.encoded).not_to match(
        /Click on the link belo to set your password/
      )
    end

    describe 'raw invitation token present' do
      let(:user) do
        User.invite!(email: Faker::Internet.email) do |u|
          u.skip_invitation = true
        end
      end

      it 'renders the body' do
        expect(mail.body.encoded).to match(
          /You have been added by #{inviter_name} to collaborate in the RaiseNation account for #{org_name}/
        )
        expect(mail.body.encoded).to match(
          /Click on the link below to set your password/
        )
      end
    end
  end
end
