class AddAccountReferenceToDonor < ActiveRecord::Migration[6.0]
  def change
    add_reference :donors, :account, index: true
  end
end
