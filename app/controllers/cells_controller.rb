class CellsController < ApplicationController
  
  def index
    @cells = Cell.all
  end
  
  def show
    @cell = cell.find(params[:id])
  end
    
  def new
    @cell = Cell.new
  end

  def create
    @cell = cell.new(cell_params)
    

    if @cell.save
      redirect_to @cell
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @cell = cell.find(params[:id])
  end

  def update
    @cell = cell.find(params[:id])

    if @cell.update(cell_params)
      redirect_to @cell
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @cell = cell.find(params[:id])
    @cell.destroy

    redirect_to root_path, status: :see_other
  end
  
  private
  
  def cell_params
    params.require(:cell).permit(:row, :column)
  end
    
end
