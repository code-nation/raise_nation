class CreateDonations < ActiveRecord::Migration[6.0]
  def change
    create_table :donations do |t|
      t.references :workflow
      t.datetime :succeeded_at
      t.monetize :amount
      t.integer :frequency
      t.string :external_id
      t.string :donor_external_id
      t.integer :donor_id, index: true
      t.jsonb :webhook_data

      t.timestamps
    end
  end
end
