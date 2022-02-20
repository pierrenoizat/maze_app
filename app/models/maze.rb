class Maze < ApplicationRecord
  
  has_many :cells, dependent: :destroy
  
  enum algo: { sidewinder: 0, aldous_broder: 1, kruskals: 2, binary_tree: 3 }
  
  validates :algo, presence: true
  validates :algo, inclusion: { in: algos.keys, message: :invalid }, :allow_nil => true
  validates :title, presence: true, length: { maximum: 25 }
  validates :row_count, presence: true, numericality: { in: 5..20 }
  validates :column_count, presence: true, numericality: { in: 5..20 }
  
  attr_reader :rows, :columns
  
  def configure_cells
    self.cells.each do |cell|
      row = cell.row
      col = cell.column
    
      if row >= 1 
        cell.north = Cell.all.select { |c| (c.row == row-1 and c.column == col) and c.maze_id == cell.maze_id }.pluck(:id).first
      end
      if row < self.row_count
        cell.south = Cell.all.select { |c| (c.row == row+1 and c.column == col) and c.maze_id == cell.maze_id }.pluck(:id).first
      end
      if col >= 1
        cell.west  = Cell.all.select { |c| (c.row == row and c.column == col-1) and c.maze_id == cell.maze_id }.pluck(:id).first
      end
      if col < self.column_count
        cell.east  = Cell.all.select { |c| (c.row == row and c.column == col+1) and c.maze_id == cell.maze_id }.pluck(:id).first
      end
      cell.save
    end
  end
  
  def to_png_v2(cell_size: 10)
    img_width = cell_size * self.column_count
    img_height = cell_size * self.row_count
    
    background = ChunkyPNG::Color::WHITE
    wall = ChunkyPNG::Color::BLACK

    img = ChunkyPNG::Image.new(img_width + 1, img_height + 1, background)

    [:backgrounds, :walls].each do |mode| 
      self.cells.each do |cell|

        x1 = cell.column * cell_size
        y1 = cell.row * cell_size
        x2 = (cell.column + 1) * cell_size
        y2 = (cell.row + 1) * cell_size

        if mode == :backgrounds
          hex_color = '#eaffff' # even lighter 
          color = ChunkyPNG::Color.from_hex(hex_color)
          img.rect(x1, y1, x2, y2, color, color) if color
        else
          img.line(x1, y1, x2, y1, wall) unless cell.north 
          img.line(x1, y1, x1, y2, wall) unless cell.west
          img.line(x2, y1, x2, y2, wall) unless cell.linked?(cell.east)
          img.line(x1, y2, x2, y2, wall) unless cell.linked?(cell.south)
        end
      end
    end

    img
  end
  
  
  def background_color_for(cell) 
      # distance = @distances[cell] or return nil
      # intensity = (@maximum - distance).to_f / @maximum 
      # dark = (255 * intensity).round
      # bright = 128 + (127 * intensity).round 
      # ChunkyPNG::Color.rgb(dark, bright, dark) # vert
      # ChunkyPNG::Color.rgb(bright, dark, dark) # bordeaux
      # hex_color = '#6388f1'
      hex_color = '#92b7ff' # lighter
      hex_color = '#eaffff' # even lighter
      ChunkyPNG::Color.from_hex(hex_color)
  end
  
  
end

