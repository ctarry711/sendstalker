class CreateFollowees < ActiveRecord::Migration[7.0]
  def change
    create_table :followees do |t|
      t.string :username, unique: true, presence: true
      t.string :realname
      t.timestamps
    end
  end
end
