class CreateRegions < ActiveRecord::Migration[7.1]
  def change
    create_table :regions do |t|
      t.string :name, null: false, comment: '地域名（例：北海道）'
      t.string :code, null: false, comment: '地域コード（例：HOKKAIDO）'

      t.timestamps
    end

    # インデックス追加
    add_index :regions, :code, unique: true
    add_index :regions, :name, unique: true
  end
end
