class CreateNations < ActiveRecord::Migration[6.0]
  def change
    create_table :nations do |t|
      t.string :slug
      t.string :token

      t.timestamps
    end
    add_index :nations, :slug
  end
end
