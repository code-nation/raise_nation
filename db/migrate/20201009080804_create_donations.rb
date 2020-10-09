class CreateDonations < ActiveRecord::Migration[6.0]
  def change
    create_table :donations do |t|
      t.references :workflow
      t.jsonb :webhook_data
      t.integer :donation_type

      t.timestamps
    end
  end
end
