class ShipsController < ApplicationController
  before_action :set_ship, only: [:show, :edit, :update, :destroy]
  before_action :create_new_form, only: [:new, :create]
  before_action :create_edit_form, only: [:edit, :update]

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
    @ship_form.submit(ship_params)

    if @ship_form.save
      redirect_to @ship_form, notice: "The <b>#{ @ship_form.name }</b> ship has been created successfully."
    else
      render :new
    end
  end

  def update
    @ship_form.submit(ship_params)

    if @ship_form.save
      redirect_to @ship_form, notice: "The <b>#{ @ship_form.name }</b> ship has been updated successfully."
    else
      render :new
    end
  end

  def destroy
    @ship.destroy
    
    if @ship.destroy
      redirect_to(ships_url, notice: "The <b>#{ @ship.name }</b> and its associated Pilots have been deleted successfully.")
    else
      redirect_to(ships_url, notice: "The <b>#{ @ship.name }</b> could not be deleted.")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ship
      @ship = Ship.find(params[:id])
    end

    def create_new_form
      ship = Ship.new
      @ship_form = ShipForm.new(ship)
    end

    def create_edit_form
      @ship_form = ShipForm.new(@ship)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ship_params
      params.require(:ship).permit(:name, :crew, :has_astromech, :speed, :armament,
        pilots_attributes: [:id, :_destroy, :first_name, :last_name, :call_sign])
    end
end
