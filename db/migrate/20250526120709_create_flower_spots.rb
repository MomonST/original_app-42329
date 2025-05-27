class CreateFlowerSpots < ActiveRecord::Migration[7.1]
  def change
    create_table :flower_spots do |t|
      t.references :flower, null: false, foreign_key: true
      t.references :mountain, null: false, foreign_key: true
      t.string :best_viewing_time, comment: '最適な観賞時期'
      t.text :notes, comment: '備考'

      t.timestamps
    end
    
    # 複合インデックス（同じ花と山の組み合わせは1つまで）
    add_index :flower_spots, [:flower_id, :mountain_id], unique: true
  end
end
