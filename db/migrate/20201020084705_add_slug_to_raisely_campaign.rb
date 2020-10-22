class AddSlugToRaiselyCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :raisely_campaigns, :slug, :string
  end
end
