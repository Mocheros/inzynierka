class SingleStatsController < ApplicationController
  before_action :set_single_stat, only: %i[ show edit update destroy ]

  # GET /single_stats or /single_stats.json
  def index
    @single_stats = SingleStat.all
  end

  # GET /single_stats/1 or /single_stats/1.json
  def show
  end

  # GET /single_stats/new
  def new
    @single_stat = SingleStat.new
  end

  # GET /single_stats/1/edit
  def edit
  end

  # POST /single_stats or /single_stats.json
  def create
    @single_stat = SingleStat.new(single_stat_params)

    respond_to do |format|
      if @single_stat.save
        format.html { redirect_to single_stat_url(@single_stat), notice: "Single stat was successfully created." }
        format.json { render :show, status: :created, location: @single_stat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @single_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /single_stats/1 or /single_stats/1.json
  def update
    respond_to do |format|
      if @single_stat.update(single_stat_params)
        format.html { redirect_to single_stat_url(@single_stat), notice: "Single stat was successfully updated." }
        format.json { render :show, status: :ok, location: @single_stat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @single_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /single_stats/1 or /single_stats/1.json
  def destroy
    @single_stat.destroy

    respond_to do |format|
      format.html { redirect_to single_stats_url, notice: "Single stat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_single_stat
      @single_stat = SingleStat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def single_stat_params
      params.require(:single_stat).permit(:game_id, :team_id, :player_id, :assistant_id, :minute, :stat_type)
    end
end
