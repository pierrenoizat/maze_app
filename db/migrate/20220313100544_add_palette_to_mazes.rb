class AddPaletteToMazes < ActiveRecord::Migration[5.2]
  def change
    add_column :mazes, :palette, :integer
  end
end
