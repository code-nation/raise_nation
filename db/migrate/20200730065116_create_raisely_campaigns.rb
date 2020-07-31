class CreateRaiselyCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :raisely_campaigns do |t|
      t.string :campaign_uuid
      t.string :api_key
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
    add_index :raisely_campaigns, :campaign_uuid
  end
end
