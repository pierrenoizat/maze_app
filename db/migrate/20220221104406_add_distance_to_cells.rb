class AddDistanceToCells < ActiveRecord::Migration[5.2]
  def change
    add_column :cells, :distance, :integer
  end
end
