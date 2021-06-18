class AddUniqueIndexToDonor < ActiveRecord::Migration[6.0]
  def change
    add_index :donors, [:donor_type, :donor_external_id], unique: true
  end
end
