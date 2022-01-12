class CreateGroupComments < ActiveRecord::Migration[5.2]
  def change
    create_table :group_comments do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
      t.text :group_comment, null: false

      t.timestamps
    end
  end
end
