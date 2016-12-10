class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change
  before_action :verify_role
 

  def index
     @roles = Role.all

  end

  def new
    @role= Role.new
  end

  def show
  end

  def edit
  end

  def create
   @role = Role.new(role_params)
   @role.typename =  @role.typename.upcase
   respond_to do |format|

    if @role.save
      format.html { redirect_to roles_path , notice: 'El rol fue creado satisfactoriamente.' }
      format.json { render :show, status: :created, location: @role }
    else
      format.html { render :new }
      format.json { render json: @role.errors, status: :unprocessable_entity }
    end
  end
end
# PATCH/PUT /Roles/1
# PATCH/PUT /Roles/1.json
def update
   @role.typename =  @role.typename.upcase
  respond_to do |format|
    if @role.update(role_params)
      if @role.valid?
        format.html { redirect_to roles_path, notice: 'El rol fue actualizado satisfactoriamente.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end
end

def verify_role
if user_signed_in?
    if current_user.role==1
      [ :edit, :index, :new]
    else
      redirect_to root_url
   end
  end
end


# DELETE /Roles/1
# DELETE /Roles/1.json
def destroy
  @role.destroy
  respond_to do |format|
    format.html { redirect_to roles_url, notice: 'Role fue borrado.' }
    format.json { head :no_content }
  end
end

  
private
  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:typename)
  end
end
