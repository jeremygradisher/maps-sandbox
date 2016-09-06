class MapsController < ApplicationController
  before_action :set_map, only: [:show, :edit, :update, :destroy]

  # GET /maps
  # GET /maps.json
  def index
    @maps = Map.all
  end

  # GET /maps/1
  # GET /maps/1.json
  def show
    #added this so I can get the image to be used as the map
    @image = @map.images.first
    @images = @map.images.all
    #added this next line - trying to figure it out
    @areas = @map.areas.all
  end

  # GET /maps/new
  def new
    @map = Map.new
    @image = @map.images.build
    @images = @map.images.all
  end

  # GET /maps/1/edit
  def edit
    @image = @map.images.build
    @images = @map.images.all
  end

  # POST /maps
  # POST /maps.json
  def create
    @map = Map.new(map_params)

    respond_to do |format|
      if @map.save
        if params.has_key?(:images)
           params[:images]['image'].each do |a|
              @image = @map.images.create!(:image => a)
           end
        end
        format.html { redirect_to @map, notice: 'Map was successfully created.' }
        format.json { render :show, status: :created, location: @map }
      else
        format.html { render :new }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maps/1
  # PATCH/PUT /maps/1.json
  def update
    respond_to do |format|
      if @map.update(map_params)
        if params.has_key?(:images)
           params[:images]['image'].each do |a|
              @image = @map.images.create!(:image => a)
           end
        end
        format.html { redirect_to @map, notice: 'Map was successfully updated.' }
        format.json { render :show, status: :ok, location: @map }
      else
        format.html { render :edit }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1
  # DELETE /maps/1.json
  def destroy
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_url, notice: 'Map was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = Map.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def map_params
      params.require(:map).permit(:name, :width, :height, images_attributes: [:id, :map_id, :image])
    end
end
