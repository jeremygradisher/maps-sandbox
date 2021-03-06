class AreasController < ApplicationController
  before_action :set_area, only: [:show, :edit, :update, :destroy]

  # GET /areas
  # GET /areas.json
  def index
    @areas = Area.all
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
    @map = Map.find(@area.map_id)
    #added this so I can get the image to be used as the map
    @image = @map.images.first
    @images = @map.images.all
  end

  # GET /areas/new
  def new
    @area = Area.new
    #testing:
    @map = Map.find(params[:map_id])
    @image = @map.images.first
    @images = @map.images.all
    @areas = @map.areas.all
  end

  # GET /areas/1/edit
  def edit
    @map = Map.find(@area.map_id)
    #added this so I can get the image to be used as the map
    @image = @map.images.first
    @images = @map.images.all
    @areas = @map.areas.all
  end

  # POST /areas
  # POST /areas.json
  def create
    @area = Area.new(area_params)
    @map = Map.find(@area.map_id)

    respond_to do |format|
      if @area.save
        format.html { redirect_to map_url(@map), notice: 'Area was successfully created.' }
        format.json { render :show, status: :created, location: @area }
      else
        format.html { render :new }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /areas/1
  # PATCH/PUT /areas/1.json
  def update
    @map = Map.find(@area.map_id)
    
    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to map_url(@map), notice: 'Area was successfully updated.' }
        format.json { render :show, status: :ok, location: @area }
      else
        format.html { render :edit }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    @area.destroy
    respond_to do |format|
      format.html { redirect_to map_path(@area.map_id), notice: 'Area was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
      params.require(:area).permit(:name, :map_id, :info, :status, :coords)
    end
end
