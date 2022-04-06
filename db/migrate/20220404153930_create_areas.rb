class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
      t.integer :area_id, unique: true, presence: true
      t.string :area_name, unique: true, presence: true
      t.integer :parent_id

      t.timestamps
    end
  end
end
