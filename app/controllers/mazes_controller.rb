class MazesController < ApplicationController
  
  def index
    @mazes = Maze.all
  end
  
  def show
    @maze = Maze.find(params[:id])
  end
    
  def new
    @maze = Maze.new
  end

  def create
    @maze = Maze.new(maze_params)

    if @maze.save
      Array.new(@maze.row_count) do |row|
        Array.new(@maze.column_count) do |column|
          @cell = Cell.new({ :row => row, :column => column, :maze_id => @maze.id })
          @cell.save
        end
      end
      @maze.configure_cells
      
      case @maze.algo
      when "sidewinder"
        row_max = @maze.row_count
        for i in 1..row_max
          @maze.reload
          row = @maze.cells.where("row = ?",i-1)
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
        cell = @maze.cells.sample 
        unvisited = @maze.cells.size - 1 

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

      else
        # binary tree algorithm
        puts "Starting Binary tree algorithm."
        @maze.cells.each do |cell|
          neighbors = []
          neighbors << cell.south if cell.south
          neighbors << cell.east if cell.east

          index = rand(neighbors.length) 
          neighbor = Cell.find_by_id(neighbors[index])
        
          cell.link(neighbor) if neighbor
          cell.save
        end

      end
      @filename = @maze.algo + "_" + @maze.id.to_s + ".png"
      @maze.file_name = @filename
      @maze.save
      @maze.reload
      @maze.to_png_v2.save(@filename)
      destination = "/Users/noizat/code/workspace/maze_app/app/assets/images/#{@filename}"
      FileUtils.copy_file(@filename, destination, preserve = false, dereference = true)
      FileUtils.rm @filename, :force => true
      redirect_to @maze
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @maze = Maze.find(params[:id])
  end

  def update
    @maze = Maze.find(params[:id])

    if @maze.update(maze_params)
      redirect_to @maze
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @maze = Maze.find(params[:id])
    @maze.cells.each do |cell|
      cell.destroy
    end
    @maze.destroy

    redirect_to root_path, status: :see_other
  end
  
  private
  
  def maze_params
    params.require(:maze).permit(:title, :algo, :row_count, :column_count)
  end
    
end
