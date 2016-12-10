class LegalAgentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_legal_agent, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change
  before_action :verify_role

  def index
    if params[:search]
      @legal_agents = LegalAgent.joins(:person).search(params[:search]).order('created_at DESC')
    else
      @legal_agents = LegalAgent.all#.order('created_at DESC')
    end
  end

  # GET /legal_agents/1
  # GET /legal_agents/1.json
  def show
  end

  # GET /legal_agents/new
  def new
    @user = User.new
    @person = Person.new
    @companies = Company.all
  end

  def new2
    @user = User.new
    @person = Person.new
    @companies = Company.all
    @company = Company.find(params[:company_id])
  end

  # GET /legal_agents/1/edit
  def edit
    @legal_agent = LegalAgent.find(params[:id])
    @person = Person.find(@legal_agent.person_id)
    @companies = Company.all
    @user = User.find(@person.user_id)
  end

  # POST /legal_agents
  # POST /legal_agents.json
  def create
    if params[:company_id]
      @company = Company.find(params[:company_id])
    end
    @companies = Company.all
    @person = Person.new(person_params)
    @user = User.new(user_params)
    respond_to do |format|
      if @person.valid?
          @company = Company.find(params[:legal_agent][:company_id])
          @user.username = @person.get_username
          @user.password = @person.get_password (@company.name)
          @user.active = true
          if @user.valid?
              @user.save
              @person.identification_type = 1
              @person.user_id = @user.id
              @person.save
              @legal_agent = LegalAgent.new(legal_agent_params)
              @legal_agent.person_id = @person.id
              @legal_agent.save
              format.html { redirect_to @legal_agent, notice: 'Representante legal creado exitosamente' }
          else
            if params[:company_id]
              format.html { render :new2 }
            else
              format.html { render :new }
            end
          end
      else
        if params[:company_id]
          format.html { render :new2 }
        else
          format.html { render :new }
        end
      end
    end
  end

  # PATCH/PUT /legal_agents/1/update
  def update
    @companies = Company.all
    @legal_agent = LegalAgent.find(params[:id])
    @person = Person.find(@legal_agent.person_id)
    @user = User.find(@person.user_id)
    respond_to do |format|
      if @person.update_attributes(person_params)
        @company = Company.find(params[:legal_agent][:company_id])
        @user.username = @person.get_username
        @user.password = @person.get_password (@company.name)
        if @user.update_attributes(user_params)
           @legal_agent.update_attributes(legal_agent_params)
           format.html { redirect_to @legal_agent, notice: 'Representante legal actualizado exitosamente' }
        else
          format.html { render :new }
        end
      else
        format.html { render :new }
      end
    end
  end

  # DELETE /legal_agents/1
  # DELETE /legal_agents/1.json
  def destroy
    @legal_agent.destroy
    respond_to do |format|
      format.html { redirect_to legal_agents_url, notice: 'Representante Legal eliminado' }
      format.json { head :no_content }
    end
  end

  def verify_role
  if user_signed_in?
    if current_user.role==1  || current_user.role == 2
      [ :edit, :index, :new, :show]
    elsif current_user.role==1
        [ :show]
    else
      redirect_to root_url
    end
   end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_legal_agent
      @legal_agent = LegalAgent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def legal_agent_params
      params.require(:legal_agent).permit(:company_id)
    end

    def person_params
      params.require(:person).permit(:identification_number, :identification_type, :first_name, :last_name, :phone_number, :country, :city, :address)
    end

    def user_params
      params.require(:user).permit(:role, :email, :active)
    end

end
