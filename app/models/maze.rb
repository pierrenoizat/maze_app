class Maze < ApplicationRecord
  
  has_many :cells, dependent: :destroy
  
  enum algo: { sidewinder: 0, aldous_broder: 1, kruskals: 2, binary_tree: 3 }
  enum color: { white: 0, burgundy: 1, green: 2, blue: 3, kaki: 4, turquoise: 5, aliceblue: 6, burlywood: 7, fuchsia: 8,
               khaki: 9, lavender: 10, lightsalmon: 11,
                   antiquewhite: 12,
                   aqua: 13,
                   aquamarine: 14,
                   azure: 15,
                   beige: 16,
                   bisque: 17,
                   black: 18,
                   blanchedalmond: 19,
                   blueviolet: 21,
                   brown: 22,
                   cadetblue: 23,
                   chartreuse: 24,
                   chocolate: 25,
                   coral: 26,
                   cornflowerblue: 27,
                   cornsilk: 28,
                   crimson: 29,
                   cyan: 30,
                   darkblue: 31,
                   darkcyan: 32,
                   darkgoldenrod: 33,
                   darkgray: 34,
                   darkgrey: 35,
                   darkgreen: 36,
                   darkkhaki: 37,
                   darkmagenta: 38,
                   darkolivegreen: 39,
                   darkorange: 40,
                   darkorchid: 41,
                   darkred: 42,
                   darksalmon: 43,
                   darkseagreen: 44,
                   darkslateblue: 45,
                   darkslategray: 46,
                   darkslategrey: 47,
                   darkturquoise: 48,
                   darkviolet: 49,
                   deeppink: 50,
                   deepskyblue: 51,
                   dimgray: 52,
                   dimgrey: 53,
                   dodgerblue: 54,
                   firebrick: 55,
                   floralwhite: 56,
                   forestgreen: 57,
                   gainsboro: 58,
                   ghostwhite: 59,
                   gold: 60,
                   goldenrod: 61,
                   gray: 62,
                   grey: 63,
                   greenyellow: 65,
                   honeydew: 66,
                   hotpink: 67,
                   indianred: 68,
                   indigo: 69,
                   ivory: 70,
                   lavenderblush: 71,
                   lawngreen: 72,
                   lemonchiffon: 73,
                   lightblue: 74,
                   lightcoral: 75,
                   lightcyan: 76,
                   lightgoldenrodyellow: 77,
                   lightgray: 78,
                   lightgrey: 79,
                   lightgreen: 80,
                   lightpink: 81,
                   lightseagreen: 82,
                   lightskyblue: 83,
                   lightslategray: 84,
                   lightslategrey: 85,
                   lightsteelblue: 86,
                   lightyellow: 87,
                   lime: 88,
                   limegreen: 89,
                   linen: 90,
                   magenta: 91,
                   maroon: 92,
                   mediumaquamarine: 93,
                   mediumblue: 94,
                   mediumorchid: 95,
                   mediumpurple: 96,
                   mediumseagreen: 97,
                   mediumslateblue: 98,
                   mediumspringgreen: 99,
                   mediumturquoise: 100,
                   mediumvioletred: 101,
                   midnightblue: 102,
                   mintcream: 103,
                   mistyrose: 104,
                   moccasin: 105,
                   navajowhite: 106,
                   navy: 107,
                   oldlace: 108,
                   olive: 109,
                   olivedrab: 110,
                   orange: 111,
                   orangered: 112,
                   orchid: 113,
                   palegoldenrod: 114,
                   palegreen: 115,
                   paleturquoise: 116,
                   palevioletred: 117,
                   papayawhip: 118,
                   peachpuff: 119,
                   peru: 120,
                   pink: 121,
                   plum: 122,
                   powderblue: 123,
                   purple: 124,
                   red: 125,
                   rosybrown: 126,
                   royalblue: 127,
                   saddlebrown: 128,
                   salmon: 129,
                   sandybrown: 130,
                   seagreen: 131,
                   seashell: 132,
                   sienna: 133,
                   silver: 134,
                   skyblue: 135,
                   slateblue: 136,
                   slategray: 137,
                   slategrey: 138,
                   snow: 139,
                   springgreen: 140,
                   steelblue: 141,
                   tan: 142,
                   teal: 143,
                   thistle: 144,
                   tomato: 145,
                   turquoise: 146,
                   violet: 20,
                   wheat: 64,
                   whitesmoke: 147,
                   yellow: 148,
                   yellowgreen: 149
               }
  
  validates :algo, presence: true
  validates :algo, inclusion: { in: algos.keys, message: :invalid }, :allow_nil => true
  validates :title, presence: true, length: { maximum: 25 }
  validates :row_count, presence: true, numericality: { in: 5..20 }
  validates :column_count, presence: true, numericality: { in: 5..20 }
  validates :algo, inclusion: { in: algos.keys, message: :invalid }, :allow_nil => true
  validates :background, inclusion: { in: ['white','burgundy','green','blue', 'kaki','turquoise'], message: :invalid }, :allow_nil => true
  validates :color, inclusion: { in: colors.keys, message: :invalid }, :allow_nil => true
  
  attr_reader :rows, :columns
  
  include ChunkyPNG
  
  def goal
    #root_row = 0
    #root_column = 0
    root_row = self.row_count/2
    root_column = self.column_count/2
    self.cells.select { |c| c.row == root_row and c.column == root_column }.first
  end
  
  def compute_distances
    
    frontier = [ self.goal ]
    distances = {}
    distances[self.goal.id] = 0
    while frontier.any? 
      new_frontier = []
      frontier.each do |cell| 
        cell.links.each do |linked| 
          next if distances[linked]
          distances[linked] = distances[cell.id] + 1
          
          new_frontier << Cell.find_by_id(linked)
        end 
      end
      frontier = new_frontier
    end
    self.cells.each do |cell|
      cell.distance = distances[cell.id]
      cell.save
    end
  end

  
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
          #hex_color = '#eaffff' # even lighter 
          #color = ChunkyPNG::Color.from_hex(hex_color)
          color = background_color_for(cell)
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
    maximum = self.cells.pluck(:distance).compact.max
    distance = cell.distance or return nil
    intensity = (maximum - distance).to_f / maximum
    dark = (255 * intensity).round
    bright = 128 + (127 * intensity).round
    case self.color
      when 'burgundy'
        Color.rgb(bright, dark, dark)
      when 'green'
        Color.rgb(dark, bright, dark)
      when 'blue'
        Color.rgb(dark, dark, bright)
      when 'kaki'
        Color.rgb(bright, bright, dark)
      else
        predefined_color = Color::PREDEFINED_COLORS[self.color.to_sym]
        get_rgb_color(predefined_color, intensity)
    end
  end
  
  def get_rgb_color(predefined_color, intensity)
    hex_color = "0x"+ predefined_color.to_s(16)
    color = Color.from_hex(hex_color)
    red = ( Color.r(color) * intensity ).round
    green = ( Color.g(color) * intensity ).round
    blue = ( Color.b(color) * intensity ).round
    Color.rgb(red, green, blue)
  end
  
  
end

