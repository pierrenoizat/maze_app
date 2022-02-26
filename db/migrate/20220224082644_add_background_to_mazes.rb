class AddBackgroundToMazes < ActiveRecord::Migration[5.2]
  def change
    add_column :mazes, :background, :string
  end
end
