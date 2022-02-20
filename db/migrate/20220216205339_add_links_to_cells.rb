class AddLinksToCells < ActiveRecord::Migration[5.2]
  def change
    add_column :cells, :links, :integer, array: true, default: [], null: false
  end
end