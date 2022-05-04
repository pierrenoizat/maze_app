class AddWallToMazes < ActiveRecord::Migration[7.1]
  def change
    add_column :mazes, :wall, :integer
  end
end
