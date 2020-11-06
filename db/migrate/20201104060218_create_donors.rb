class CreateDonors < ActiveRecord::Migration[6.0]
  def change
    create_table :donors do |t|
      t.integer :donor_type
      t.string :donor_tags, array: true, default: []
      t.string :recurring_donor_tags, array: true, default: []
      t.string :donor_external_id
      t.jsonb :donor_data

      t.timestamps
    end
  end
end
