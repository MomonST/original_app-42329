class CreateMountains < ActiveRecord::Migration[7.1]
  def change
    create_table :mountains do |t|
      t.string :name, null: false, comment: '山名'
      t.integer :elevation, comment: '標高（メートル）'
      t.decimal :latitude, precision: 10, scale: 6, comment: '緯度'
      t.decimal :longitude, precision: 10, scale: 6, comment: '経度'
      t.references :region, null: false, foreign_key: true, comment: '地域ID'
      t.string :prefecture, comment: '都道府県'
      t.text :description, comment: '説明'

      t.timestamps
    end

    # インデックス追加
    add_index :mountains, :name
    add_index :mountains, :prefecture
    add_index :mountains, :elevation
    add_index :mountains, [:latitude, :longitude]
  end
end
