class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change
  before_action :check_role

  def check_role
    if user_signed_in?
      if current_user.role != 1
        redirect_to '/'
      end
    end
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all.paginate(:page => params[:page], :per_page => 10)
    if params[:search]
        @users = User.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
      else
        @users = User.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
    end

  end

  # GET /users/1
  # GET /users/1.json
  def show
    person = @user.person
    if person.employee
      redirect_to person.employee
    else
      redirect_to person.legal_agent
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.active = true
    # @user.password_alteration = false
    # if @user.save
    #   redirect_to @user
    # else
    #   if @user.password.length < 8
    #     redirect_to '/error', notice: 'Password debe tener minimo 8 caracteres'
    #   else
    #     redirect_to '/error', notice: 'El email que se quiere utilizar ya se encuentra en uso o no tiene un formato valido'
    #   end
    # end
    # format.html { redirect_to @user, notice: 'User was successfully created.' }

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def annul
    @user = User.find(params[:id])
    @user.update_attribute(:active, false)
    redirect_to @user
  end

  def activate
    @user = User.find(params[:id])
    @user.update_attribute(:active, true)
    redirect_to @user
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'El usuario fue actulizado.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'usuario fue anulado.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:role, :email, :username, :password, :active)
    end
end
