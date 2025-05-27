class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bloom_report, null: false, foreign_key: true

      t.timestamps
    end

    # 同じユーザーが同じ投稿に複数いいねできないように
    add_index :likes, [:user_id, :bloom_report_id], unique: true
  end
end
