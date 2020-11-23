class AddProfileUuidToRaiselyCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :raisely_campaigns, :profile_uuid, :string
  end
end
