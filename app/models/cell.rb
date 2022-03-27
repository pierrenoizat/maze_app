class Cell < ApplicationRecord
  
  belongs_to :maze
  
  def avalanche
    cell = Cell.find_by_id(self.east)
    cell.distance += 1 if cell
    cell.save if cell
    
    cell = Cell.find_by_id(self.west)
    cell.distance += 1 if cell
    cell.save if cell
    
    cell = Cell.find_by_id(self.north)
    cell.distance += 1 if cell
    cell.save if cell
    
    cell = Cell.find_by_id(self.south)
    cell.distance += 1 if cell
    cell.save if cell
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
