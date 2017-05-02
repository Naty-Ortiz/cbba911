class ContravertionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contravertion, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change
  before_action :verify_role
  autocomplete :contravertion, :name

  # GET /contravertions
  # GET /contravertions.json
  def index
       if params[:search]
          @contravertions = Contravertion.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
       else
          @contravertions = Contravertion.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
       end
  end

  # GET /contravertions/1
  # GET /contravertions/1.json
  def show
  end

  # GET /contravertions/new
  def new
    @contravertion= Contravertion.new
  end

  # GET /contravertions/1/edit
  def edit
  end

  # POST /contravertions
  # POST /contravertions.json
  def create
    @contravertion = Contravertion.new(contravertion_params)
    @contravertion.name = @contravertion.name.upcase
    respond_to do |format|
      if @contravertion.save
        format.html { redirect_to @contravertion, notice: 'Contraversionregistrada exitosamente' }
        format.json { render :show, status: :created, location: @contravertion }
      else
        format.html { render :new }
        format.json { render json: @contravertion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contravertions/1
  # PATCH/PUT /contravertions/1.json
  def update
      @contravertion.name = @contravertion.name.upcase
    respond_to do |format|
      if @contravertion.update(contravertion_params)
          format.html { redirect_to @contravertion, notice: 'Contraversion actualizada exitosamente' }
          format.json { render :show, status: :ok, location: @contravertion }
        else
          format.html { render :edit }
          format.json { render json: @contravertion.errors, status: :unprocessable_entity }
       end
    end
  end

  # DELETE /contravertions/1
  # DELETE /contravertions/1.json
  def destroy
    @contravertion.destroy
    respond_to do |format|
      format.html { redirect_to contravertions_url, notice: 'Contravertion eliminada' }
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
    def set_contravertion
      @contravertion = Contravertion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contravertion_params
      params.require(:contravertion).permit(:name, :code)
    end
end
