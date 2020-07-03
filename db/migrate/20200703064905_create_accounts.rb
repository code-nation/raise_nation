class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :organisation_name
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
