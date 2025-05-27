class CreateBloomReports < ActiveRecord::Migration[7.1]
  def change
    create_table :bloom_reports do |t|
      t.references :user, null: false, foreign_key: true, comment: '投稿者'
      t.references :flower_spot, null: false, foreign_key: true, comment: '花スポット'
      t.string :title, null: false, comment: '投稿タイトル'
      t.text :description, comment: '投稿内容'
      t.integer :bloom_status, default: 0, comment: '開花状況（0:つぼみ, 1:咲き始め, 2:見頃, 3:散り始め, 4:終了）'
      t.integer :view_count, default: 0, comment: '閲覧数'
      t.integer :likes_count, default: 0, comment: 'いいね数'
      t.integer :status, default: 0, comment: '承認状況（0:審査中, 1:承認済み, 2:却下）'
      t.datetime :reported_at, null: false, comment: '報告日時'

      t.timestamps
    end

    # インデックス追加
    add_index :bloom_reports, :status
    add_index :bloom_reports, :reported_at
    add_index :bloom_reports, :view_count
    add_index :bloom_reports, :likes_count
    add_index :bloom_reports, [:flower_spot_id, :reported_at]
  end
end