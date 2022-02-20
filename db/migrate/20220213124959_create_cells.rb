class CreateCells < ActiveRecord::Migration[5.2]
  def change
    create_table :cells do |t|
      t.integer :row
      t.integer :column
      t.integer :height
      t.integer :level
      t.integer :north
      t.integer :south
      t.integer :east
      t.integer :west
      t.references :maze, null: false, foreign_key: true

      t.timestamps
    end
  end
end
