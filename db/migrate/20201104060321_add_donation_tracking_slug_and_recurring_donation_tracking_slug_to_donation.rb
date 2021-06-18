class AddDonationTrackingSlugAndRecurringDonationTrackingSlugToDonation < ActiveRecord::Migration[6.0]
  def change
    add_column :donations, :donation_tracking_slug, :string
    add_column :donations, :recurring_donation_tracking_slug, :string
  end
end
