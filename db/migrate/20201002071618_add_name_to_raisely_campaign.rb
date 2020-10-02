class AddNameToRaiselyCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :raisely_campaigns, :name, :string
  end
end
