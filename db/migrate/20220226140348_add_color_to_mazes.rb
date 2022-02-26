class AddColorToMazes < ActiveRecord::Migration[5.2]
  def change
    add_column :mazes, :color, :integer
  end
end
