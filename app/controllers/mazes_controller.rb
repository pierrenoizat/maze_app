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
      @maze.execute_algorithm
      @colored_maze = @maze.algo + "_" + @maze.id.to_s + ".png"
      @maze.file_name = @colored_maze
      @maze.save
      @maze.reload
      @maze.compute_distances
      @maze.save
      @maze.reload
      # @maze.to_png.save(@colored_maze)
      @maze.to_png.save(@colored_maze)
      destination = "/Users/noizat/code/workspace/maze_app/app/assets/images/#{@colored_maze}"
      FileUtils.copy_file(@colored_maze, destination, preserve = false, dereference = true)
      FileUtils.rm @colored_maze, :force => true
      @white_maze = "white_" + @colored_maze
      @maze.to_png(solution:false).save(@white_maze)
      destination = "/Users/noizat/code/workspace/maze_app/app/assets/images/#{@white_maze}"
      FileUtils.copy_file(@white_maze, destination, preserve = false, dereference = true)
      FileUtils.rm @white_maze, :force => true
      redirect_to @maze, success: "Maze was created and saved successfully."
    else
      redirect_to new_maze_path, danger: "Maze could not be saved: some field must be missing."
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
   
    destination = "/Users/noizat/code/workspace/maze_app/app/assets/images/#{@maze.file_name}"
    FileUtils.rm destination, :force => true
    destination = "/Users/noizat/code/workspace/maze_app/app/assets/images/white_" + "#{@maze.file_name}"
    FileUtils.rm destination, :force => true
    @maze.destroy

    redirect_to root_path, status: :see_other
  end
  
  private
  
  def maze_params
    params.require(:maze).permit(:title, :algo, :row_count, :column_count, :background, :color, :palette, :wall)
  end
    
end
