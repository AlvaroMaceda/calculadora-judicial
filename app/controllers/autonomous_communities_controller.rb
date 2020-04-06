class AutonomousCommunitiesController < ApplicationController
  before_action :set_autonomous_community, only: [:show, :edit, :update, :destroy]

  # GET /autonomous_communities
  # GET /autonomous_communities.json
  def index
    @autonomous_communities = AutonomousCommunity.all
  end

  # GET /autonomous_communities/1
  # GET /autonomous_communities/1.json
  def show
  end

  # GET /autonomous_communities/new
  def new
    @autonomous_community = AutonomousCommunity.new
  end

  # GET /autonomous_communities/1/edit
  def edit
  end

  # POST /autonomous_communities
  # POST /autonomous_communities.json
  def create
    @autonomous_community = AutonomousCommunity.new(autonomous_community_params)

    respond_to do |format|
      if @autonomous_community.save
        format.html { redirect_to @autonomous_community, notice: 'Autonomous community was successfully created.' }
        format.json { render :show, status: :created, location: @autonomous_community }
      else
        format.html { render :new }
        format.json { render json: @autonomous_community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /autonomous_communities/1
  # PATCH/PUT /autonomous_communities/1.json
  def update
    respond_to do |format|
      if @autonomous_community.update(autonomous_community_params)
        format.html { redirect_to @autonomous_community, notice: 'Autonomous community was successfully updated.' }
        format.json { render :show, status: :ok, location: @autonomous_community }
      else
        format.html { render :edit }
        format.json { render json: @autonomous_community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /autonomous_communities/1
  # DELETE /autonomous_communities/1.json
  def destroy
    @autonomous_community.destroy
    respond_to do |format|
      format.html { redirect_to autonomous_communities_url, notice: 'Autonomous community was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_autonomous_community
      @autonomous_community = AutonomousCommunity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def autonomous_community_params
      params.require(:autonomous_community).permit(:name, :Country_id)
    end
end
