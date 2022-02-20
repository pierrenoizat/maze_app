class AddRowCountToMazes < ActiveRecord::Migration[5.2]
  def change
    add_column :mazes, :row_count, :integer
    add_column :mazes, :column_count, :integer
  end
end
