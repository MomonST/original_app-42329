class CreateFlowers < ActiveRecord::Migration[7.1]
  def change
    create_table :flowers do |t|
      t.string :name, null: false, comment: '花名'
      t.string :scientific_name, comment: '学名'
      t.text :description, comment: '説明'
      t.string :color, comment: '花の色'
      t.string :size, comment: '花のサイズ'
      t.string :habitat, comment: '生息環境'
      t.integer :bloom_start_month, null: false, comment: '開花開始月'
      t.integer :bloom_end_month, null: false, comment: '開花終了月'
      t.integer :peak_month, comment: '開花ピーク月'
      t.integer :altitude_min, comment: '最低標高'
      t.integer :altitude_max, comment: '最高標高'
      t.integer :difficulty_level, default: 0, comment: '難易度（0:初級, 1:中級, 2:上級）'
      t.string :image_url, comment: '画像URL'

      t.timestamps
    end

    # インデックス追加
    add_index :flowers, :name
    add_index :flowers, :bloom_start_month
    add_index :flowers, :bloom_end_month
    add_index :flowers, :difficulty_level
  end
end