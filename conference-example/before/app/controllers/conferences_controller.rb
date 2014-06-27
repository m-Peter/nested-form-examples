class ConferencesController < ApplicationController
  before_action :set_conference, only: [:show, :edit, :update, :destroy]

  # GET /conferences
  # GET /conferences.json
  def index
    @conferences = Conference.all
  end

  # GET /conferences/1
  # GET /conferences/1.json
  def show
  end

  # GET /conferences/new
  def new
    @conference = Conference.new
    @conference.build_speaker
    2.times { @conference.speaker.presentations.build }
  end

  # GET /conferences/1/edit
  def edit
  end

  # POST /conferences
  # POST /conferences.json
  def create
    @conference = Conference.new(conference_params)

    respond_to do |format|
      if @conference.save
        format.html { redirect_to @conference, notice: "Conference: #{@conference.name} was successfully created." }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /conferences/1
  # PATCH/PUT /conferences/1.json
  def update
    respond_to do |format|
      if @conference.update(conference_params)
        format.html { redirect_to @conference, notice: "Conference: #{@conference.name} was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.json
  def destroy
    name = @conference.name
    @conference.destroy
    respond_to do |format|
      format.html { redirect_to conferences_url, notice: "Conference: #{name} was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conference
      @conference = Conference.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conference_params
      params.require(:conference).permit(:name, :city, speaker_attributes: [:id, :name, :occupation, 
        presentations_attributes: [:id, :topic, :duration]])
    end
end
