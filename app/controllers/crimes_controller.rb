class CrimesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_crime, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change
  before_action :verify_role
  autocomplete :crime, :name
  # GET /crimes
  # GET /crimes.json
  def index
  
       if params[:search]
          @crimes = Crime.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
       else
          @crimes = Crime.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
       end
  end

  # GET /crimes/1
  # GET /crimes/1.json
  def show
  end

  # GET /crimes/new
  def new
    @crime= Crime.new
  end

  # GET /crimes/1/edit
  def edit
  end

  # POST /crimes
  # POST /crimes.json
  def create
    @crime = Crime.new(crime_params)
    @crime.name = @crime.name.upcase
    respond_to do |format|
      if @crime.save
        format.html { redirect_to @crime, notice: 'Contraversionregistrada exitosamente' }
        format.json { render :show, status: :created, location: @crime }
      else
        format.html { render :new }
        format.json { render json: @crime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crimes/1
  # PATCH/PUT /crimes/1.json
  def update
      @crime.name = @crime.name.upcase
    respond_to do |format|
      if @crime.update(crime_params)
          format.html { redirect_to @crime, notice: 'Contraversion actualizada exitosamente' }
          format.json { render :show, status: :ok, location: @crime }
        else
          format.html { render :edit }
          format.json { render json: @crime.errors, status: :unprocessable_entity }
       end
    end
  end

  # DELETE /crimes/1
  # DELETE /crimes/1.json
  def destroy
    @crime.destroy
    respond_to do |format|
      format.html { redirect_to crimes_url, notice: 'crime eliminada' }
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
    def set_crime
      @crime = Crime.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crime_params
      params.require(:crime).permit(:name, :code)
    end
end
