class CreateWorkflows < ActiveRecord::Migration[6.0]
  def change
    create_table :workflows do |t|
      t.string :name
      t.references :source, null: false, polymorphic: true
      t.references :target, null: false, polymorphic: true
      t.references :account, null: false, foreign_key: true
      t.string :donor_tag
      t.string :recurring_donor_tag
      t.boolean :is_active

      t.timestamps
    end
  end
end
