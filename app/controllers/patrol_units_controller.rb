class PatrolUnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patrol_unit, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change
  before_action :verify_role

  # GET /patrolUnits
  # GET /patrolUnits.json
  def index

       if params[:search]
          @patrol_units = PatrolUnit.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
       else
          @patrol_units = PatrolUnit.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
       end
  end

  # GET /patrolUnits/1
  # GET /patrolUnits/1.json
  def show
  end

  # GET /patrolUnits/new
  def new
    @patrol_unit= PatrolUnit.new
  end

  # GET /patrolUnits/1/edit
  def edit
  end

  # POST /patrolUnits
  # POST /patrolUnits.json
  def create
    @patrol_unit = PatrolUnit.new(patrol_unit_params)
    @patrol_unit.name = @patrol_unit.name.upcase
    respond_to do |format|
      if @patrol_unit.save
        format.html { redirect_to @patrol_unit, notice: 'Contraversionregistrada exitosamente' }
        format.json { render :show, status: :created, location: @patrol_unit }
      else
        format.html { render :new }
        format.json { render json: @patrol_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patrolUnits/1
  # PATCH/PUT /patrolUnits/1.json
  def update
  #    @patrol_unit.name = @patrol_unit.name.upcase
    respond_to do |format|
      if @patrol_unit.update(patrol_unit_params)
          format.html { redirect_to @patrol_unit, notice: 'Contraversion actualizada exitosamente' }
          format.json { render :show, status: :ok, location: @patrol_unit }
        else
          format.html { render :edit }
          format.json { render json: @patrol_unit.errors, status: :unprocessable_entity }
       end
    end
  end

  # DELETE /patrolUnits/1
  # DELETE /patrolUnits/1.json
  def destroy
    @patrol_unit.destroy
    respond_to do |format|
      format.html { redirect_to patrol_units_url, notice: 'unidad de patrulla eliminada' }
      format.json { head :no_content }
    end
  end

  def verify_role
    if user_signed_in?
      if current_user.role==2 || current_user.role == 1
        [ :edit, :index, :new, :show]
      else
        redirect_to root_url
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patrol_unit
      @patrol_unit = PatrolUnit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patrol_unit_params
      params.require(:patrol_unit).permit(:name, :code)
    end
end
