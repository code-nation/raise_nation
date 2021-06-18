class AddTrackingSlugColumnsToWorkflow < ActiveRecord::Migration[6.0]
  def change
    add_column :workflows, :donation_tracking_slug, :string
    add_column :workflows, :recurring_donation_tracking_slug, :string
  end
end
