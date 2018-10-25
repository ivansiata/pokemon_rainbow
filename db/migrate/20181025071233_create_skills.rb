class CreateSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
      t.string :name, limit: 45, null: false
      t.integer :power, null: false
      t.integer :max_pp, null: false
      t.string :element_type, limit: 45, null: false

      t.timestamps
    end

    add_index :skills, :name, unique: true
  end
end
