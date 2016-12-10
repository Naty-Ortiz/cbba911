class ComplainantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_complain, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change

  def index
      if user_signed_in?
          @role_current_user = current_user.role
        puts current_user.role
        if    @role_current_user==2 ||   @role_current_user==3||   @role_current_user==1 || @role_current_user==5
           @complainants = Complainant.all
              if params[:search]
                @complainants = Complainant.search(params[:search]).order("created_at DESC")
              else
                @complainants = Complainant.all.order('created_at ASC')
              end

      #  elsif    @role_current_user==3

      #    @legal_agent_company_id =  current_user.person.legal_agent

      #      if @legal_agent_company_id!=nil
      #          @legal_agent_company_id =  current_user.person.legal_agent.company_id
      #      end
      #      @complains= Complain.where(company_id: @legal_agent_company_id )
      #   elsif   @role_current_user!=2 ||  @role_current_user!=4 ||   @role_current_user!=1 ||    @role_current_user!=3
      #     redirect_to root_url
        end
      @complainants
     end
  end
  # GET /complains/1
  # GET /complains/1.json
  def show
  end

  # GET /complains/new
  def new
      if current_user.role==2 ||current_user.role==1
        @complainants = Complain.new

        #@crimes = Company.get_crimes_with_legal_agents
      else
        redirect_to root_url
      end
end
  # GET /complains/1/edit
  def edit
      if current_user.role==2 ||current_user.role==1
        @complainant = Complainant.find(params[:id])
      else
        redirect_to root_url
      end
  end

  # POST /complains
  # POST /complains.json
  def create
    @complainants = Complainant.new(complain_params)


    respond_to do |format|
      if @complain.save
        format.html { redirect_to @complain}
        format.json { render :show, status: :created, location: @complain }
      else
        format.html { render :new }
        format.json { render json: @complain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /complains/1
  # PATCH/PUT /complains/1.json
  def update
      @complainant = Complainant.find(params[:id])

    respond_to do |format|
      if @complainant.update(complain_params)
        format.html { redirect_to @complain }
        format.json { render :show, status: :ok, location: @complainant }
      else
        format.html { render :edit }
        format.json { render json: @complainant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /complains/1
  # DELETE /complains/1.json
  def destroy
    @complainant.destroy
    respond_to do |format|
      format.html { redirect_to complains_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_complain
      @complain = Complainant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def complain_params
      params.require(:complainant).permit(:name, :last_name,:ci, :phone, :address)
    end
end
