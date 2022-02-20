class Cell < ApplicationRecord
  
  belongs_to :maze
  
  
  def neighbors

    row = self.row
    col = self.column
    
    if row >= 1 
      self.north = Cell.where("row = ? AND column = ?", row-1, col).pluck(:id).first
    end
    if row < self.maze.row_count-1
      self.south = Cell.where("row = ? AND column = ?", row+1, col).pluck(:id).first
    end
    if col >= 1
      self.west  = Cell.where("row = ? AND column = ?", row, col-1).pluck(:id).first
    end
    if col < self.maze.column_count-1
      self.east  = Cell.where("row = ? AND column = ?", row, col+1).pluck(:id).first
    end
  end
  
  def linked?(i)
    self.links.include?(i) 
  end
  
  def link(cell, bidi=true)
    self.links << cell.id
    cell.link(self, false) if bidi
  end
  
  def unlink(cell, bidi=true)
    self.links.delete(cell.id)
    cell.unlink(self, false) if bidi
    self
  end
  
  
  
end
