class AddFileNameToMazes < ActiveRecord::Migration[5.2]
  def change
    add_column :mazes, :file_name, :string
  end
end
