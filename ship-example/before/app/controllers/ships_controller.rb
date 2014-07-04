class ShipsController < ApplicationController
  before_action :set_ship, only: [:show, :edit, :update, :destroy]

  def index
    @ships = Ship.all
  end

  def show
  end

  def new
    @ship = Ship.new
  end

  def edit
  end

  def create
    @ship = Ship.new(ship_params)

    if @ship.save
      flash[:notice] = "The <b>#{ @ship.name }</b> ship has been saved successfully."
      redirect_to ships_path, :notice => "The <b>#{ @ship.name }</b> ship has been saved successfully."
    else
      render :new, :error => @ship.errors
    end
  end

  def update
    if @ship.update_attributes(ship_params)
      redirect_to ships_path, :notice => "The <b>#{ @ship.name }</b> ship has been updated successfully."
    else
      render :edit, :error => @ship.errors
    end
  end

  def destroy
    if @ship.destroy
      redirect_to ships_path, :notice => "The <b>#{ @ship.name }</b> and its associated Pilots have been deleted successfully."
    else
      redirect_to ships_path, :notice => "The <b>#{ @ship.name }</b> could not be deleted."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ship
      @ship = Ship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ship_params
      params.require(:ship).permit(:name, :crew, :has_astromech, :speed, :armament,
        pilots_attributes: [:id, :_destroy, :first_name, :last_name, :call_sign])
    end
end
