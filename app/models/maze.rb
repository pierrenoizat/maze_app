class Maze < ApplicationRecord
  
  has_many :cells, dependent: :destroy
  
  enum algo: { sidewinder: 0, aldous_broder: 1, kruskals: 2, binary_tree: 3, sand_pile: 4 }
  enum wall: { no_walls: 0, black_walls: 1, white_walls: 2 }
  enum palette: { plain_red: 0, plain_orange: 1, plain_yellow: 2, light_green: 3,plain_green: 4, 
              marine_green: 5, light_blue: 6, plain_blue: 7, marine_blue: 8, plain_violet: 9,
               plain_pink: 10, plain_purple: 11, plain_grey: 12}
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
  validates :palette, inclusion: { in: palettes.keys, message: :invalid }, :allow_nil => true
  validates :wall, inclusion: { in: walls.keys, message: :invalid }, :allow_nil => true
  
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
    if self.algo == 'sand_pile'
      self.cells.each do |cell|
        cell.distance = 0
        cell.save
      end
      i = 0
      while i < 300
        cell = self.cells.sample
        cell.distance += 1
        cell.save
        while self.cells.pluck(:distance).compact.max > 3
          cell = self.cells.select { |c| c.distance > 3 }.sample
          cell.distance -= 4
          cell.save
          cell.avalanche
        end
        i += 1
        # save img file
      end
      
    else
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
  
  def to_png(cell_size: 10, solution:true, inset:0)
    img_width = cell_size * self.column_count
    img_height = cell_size * self.row_count
    inset = (cell_size * inset).to_i
    
    background = Color::WHITE
    
    case self.wall
      when 'black_walls'
        wall = Color::BLACK
      when 'white_walls'
        wall = Color::WHITE
      else
        wall = "no_walls"
    end

    img = Image.new(img_width + 1, img_height + 1, background)

    [:backgrounds, :walls].each do |mode| 
      self.cells.each do |cell|
        
        x = cell.column * cell_size
        y = cell.row * cell_size
        if inset > 0
          to_png_with_inset(img, cell, mode, cell_size, wall, x, y, inset)
        else
          to_png_without_inset(img, cell, mode, cell_size, solution, wall, x, y)
        end
      end
    end

    img
  end
  
  def to_png_without_inset(img, cell, mode, cell_size, solution, wall, x, y) 
    x1, y1 = x, y
    x2 = x1 + cell_size
    y2 = y1 + cell_size
    unless solution
      wall = Color::BLACK
    end
    if mode == :backgrounds and solution
      color = background_color_for(cell) 
      img.rect(x, y, x2, y2, color, color) if color
    else
      unless wall
        wall = Color::BLACK
      end
      if wall != "no_walls"
        img.line(x1, y1, x2, y1, wall) unless cell.north
        img.line(x1, y1, x1, y2, wall) unless cell.west
        img.line(x2, y1, x2, y2, wall) unless cell.linked?(cell.east) 
        img.line(x1, y2, x2, y2, wall) unless cell.linked?(cell.south)
      end
    end
  end
  
  def to_png_with_inset(img, cell, mode, cell_size, wall, x, y, inset)
    x1, x2, x3, x4, y1, y2, y3, y4 = cell_coordinates_with_inset(x, y, cell_size, inset)
    if mode == :backgrounds
      #
    else
      if cell.linked?(cell.north)
        img.line(x2, y1, x2, y2, wall)
        img.line(x3, y1, x3, y2, wall)
      else
        img.line(x2, y2, x3, y2, wall)
      end
    
      if cell.linked?(cell.south)
        img.line(x2, y3, x2, y4, wall)
        img.line(x3, y3, x3, y4, wall)
      else
        img.line(x2, y3, x3, y3, wall)
      end
    
      if cell.linked?(cell.west) 
        img.line(x1, y2, x2, y2, wall) 
        img.line(x1, y3, x2, y3, wall)
      else
        img.line(x2, y2, x2, y3, wall)
      end
    
      if cell.linked?(cell.east) 
        img.line(x3, y2, x4, y2, wall) 
        img.line(x3, y3, x4, y3, wall)
      else
        img.line(x3, y2, x3, y3, wall)
      end
    end
  end
  
  def cell_coordinates_with_inset(x, y, cell_size, inset)
    x1 = x
    x4 = x + cell_size 
    x2 = x1 + inset 
    x3 = x4 - inset
    y1 = y
    y4 = y + cell_size 
    y2 = y1 + inset 
    y3 = y4 - inset
    [x1, x2, x3, x4,y1, y2, y3, y4]
  end
  
  def to_png_old(cell_size: 10, solution:true, inset:0)
    img_width = cell_size * self.column_count
    img_height = cell_size * self.row_count
    
    background = Color::WHITE
    wall = Color::BLACK

    img = Image.new(img_width + 1, img_height + 1, background)

    [:backgrounds, :walls].each do |mode| 
      self.cells.each do |cell|

        x1 = cell.column * cell_size
        y1 = cell.row * cell_size
        x2 = (cell.column + 1) * cell_size
        y2 = (cell.row + 1) * cell_size

        if mode == :backgrounds and solution
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
    intensity = 0
    intensity = (maximum - distance).to_f / maximum if maximum != 0
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
        if self.palette
          get_color_from_palette(self.palette, intensity)
        else
          predefined_color = Color::PREDEFINED_COLORS[self.color.to_sym]
          get_rgb_color(predefined_color, intensity)
        end
    end
  end
  
  def get_color_from_palette(palette,intensity)
    case self.palette
    when 'plain_red'
      h = { "0" => "0x330000", "1" => "0x660000", "2" => "0x990000", "3" => "0xCC0000",
            "4" => "0xFF0000", "5" => "0xFF3333", "6" => "0xFF6666", "7" => "0xFF9999",
            "8" => "0xFFCCCC", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'plain_yellow'
      h = { "0" => "0x331900", "1" => "0x666600", "2" => "0x999900", "3" => "0xCCCC00",
            "4" => "0xFFFF00", "5" => "0xFFFF33", "6" => "0xFFFF66", "7" => "0xFFFF99",
            "8" => "0xFFFFCC", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'plain_orange'
      h = { "0" => "0x331900", "1" => "0x663300", "2" => "0x994C00", "3" => "0xCC6600",
            "4" => "0xFF8000", "5" => "0xFF9933", "6" => "0xFFB266", "7" => "0xFFCC99",
            "8" => "0xFFE5CC", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'light_green'
      h = { "0" => "0x193300", "1" => "0x336600", "2" => "0x4C9900", "3" => "0x66CC00",
            "4" => "0x80FF00", "5" => "0x99FF33", "6" => "0xB2FF66", "7" => "0xCCFF99",
            "8" => "0xE5FFCC", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'plain_green'
      h = { "0" => "0x003300", "1" => "0x006600", "2" => "0x009900", "3" => "0x00CC00",
            "4" => "0x00FF00", "5" => "0x33FF33", "6" => "0x66FF66", "7" => "0x99FF99",
            "8" => "0xCCFFCC", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'marine_green'
      h = { "0" => "0x003319", "1" => "0x006633", "2" => "0x00994C", "3" => "0x00CC66",
            "4" => "0x00FF80", "5" => "0x33FF99", "6" => "0x66FFB2", "7" => "0x99FFCC",
            "8" => "0xCCFFE5", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'light_blue'
      h = { "0" => "0x003333", "1" => "0x006666", "2" => "0x009999", "3" => "0x00CCCC",
            "4" => "0x00FFFF", "5" => "0x33FFFF", "6" => "0x66FFFF", "7" => "0x99FFFF",
            "8" => "0xCCFFFF", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'plain_blue'
      h = { "0" => "0x001933", "1" => "0x003366", "2" => "0x004C99", "3" => "0x0066CC",
            "4" => "0x0080FF", "5" => "0x3399FF", "6" => "0x66B2FF", "7" => "0x99CCFF",
            "8" => "0xCCE5FF", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'marine_blue'
      h = { "0" => "0x000033", "1" => "0x000066", "2" => "0x000099", "3" => "0x0000CC",
            "4" => "0x0000FF", "5" => "0x3333FF", "6" => "0x6666FF", "7" => "0x9999FF",
            "8" => "0xCCCCFF", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'plain_violet'
      h = { "0" => "0x190033", "1" => "0x330066", "2" => "0x4C0099", "3" => "0x6600CC",
            "4" => "0x7F00FF", "5" => "0x9933FF", "6" => "0xB266FF", "7" => "0xCC99FF",
            "8" => "0xE5CCFF", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'plain_pink'
      h = { "0" => "0x330033", "1" => "0x660066", "2" => "0x990099", "3" => "0xCC00CC",
            "4" => "0xFF00FF", "5" => "0xFF33FF", "6" => "0xFF66FF", "7" => "0xFF99FF",
            "8" => "0xFFCCFF", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    when 'plain_purple'
      h = { "0" => "0x330019", "1" => "0x660033", "2" => "0x99004C", "3" => "0xCC0066",
            "4" => "0xFF007F", "5" => "0xFF3399", "6" => "0xFF66B2", "7" => "0xFF99CC",
            "8" => "0xFFCCE5", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    else 
      h = { "0" => "0x000000", "1" => "0x202020", "2" => "0x404040", "3" => "0x606060",
            "4" => "0x808080", "5" => "0xA0A0A0", "6" => "0xC0C0C0", "7" => "0xE0E0E0",
            "8" => "0xFFFFFF", "9" => "0xFFFFFF", "10" => "0xFFFFFF" }
    end
    
    i = ((intensity*100).round/10).to_s
    hex_color = h[i]
    color = Color.from_hex(hex_color)
    red = Color.r(color)
    green = Color.g(color)
    blue = Color.b(color)
    
    Color.rgb(red, green, blue)
  end
  
  def get_rgb_color(predefined_color, intensity)
    hex_color = "0x"+ predefined_color.to_s(16)
    color = Color.from_hex(hex_color)
    red = Color.r(color)
    green = Color.g(color)
    blue = Color.b(color)
    rgb = [ red, green, blue]
    case rgb.max
    when red
      intensity = (255/red).to_f * intensity
    when green
      intensity = (255/green).to_f * intensity
    when blue
      intensity = (255/blue).to_f * intensity
    end
    
    red = ( red * intensity ).round
    green = ( green * intensity ).round
    blue = ( blue * intensity ).round
    
    Color.rgb(red, green, blue)
  end
  
  def execute_algorithm
    case self.algo
    when "sidewinder"
      row_max = self.row_count
      for i in 1..row_max
        self.reload
        row = self.cells.where("row = ?",i-1)
        run = []

        row.each do |cell|
          run << cell

          at_eastern_boundary  = (cell.east == nil) 
          at_northern_boundary = (cell.north == nil) 

          should_close_out = 
            at_eastern_boundary ||
            (!at_northern_boundary && rand(2) == 0) 

          if should_close_out
            member = run.sample
            if member.north
              member.link(Cell.find_by_id(member.north))
              member.save
              cell = Cell.find_by_id(member.north)
              cell.link(Cell.find_by_id(cell.south))
              cell.save
            end
            run.clear
          else
            cell.link(Cell.find_by_id(cell.east))
            cell.save
          end
        end
      end
      
    when "aldous_broder"
      cell = self.cells.sample 
      unvisited = self.cells.size - 1 

      while unvisited > 0
        list = []
        list << cell.north if cell.north
        list << cell.south if cell.south
        list << cell.east  if cell.east
        list << cell.west  if cell.west
        neighbor = Cell.find_by_id(list.sample) 

        if neighbor.links.empty?
          cell.link(neighbor)
          cell.save
          unvisited -= 1 
        end

        cell = neighbor
        cell.save 
      end

    when "binary_tree"
      self.cells.each do |cell|
        neighbors = []
        neighbors << cell.south if cell.south
        neighbors << cell.east if cell.east

        index = rand(neighbors.length) 
        neighbor = Cell.find_by_id(neighbors[index])
      
        cell.link(neighbor) if neighbor
        cell.save
      end
    end
  end
  
  def to_png_with_inset(img, cell, mode, cell_size, wall, x, y, inset)
  end
  
  def cell_coordinates_with_inset(x, y, cell_size, inset)
  end
  
end

