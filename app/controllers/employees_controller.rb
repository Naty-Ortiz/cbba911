class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change
  before_action :check_role

  def check_role
    if user_signed_in?
      if current_user.role != 1
        redirect_to root_url
      end
    end
  end



  def index
    if params[:search]
      @employees = Employee.joins(:person).search(params[:search]).order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
    else
      @employees = Employee.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
    end

  end

  def show
    @employee = Employee.find(params[:id])

  end
  def getRoles

    @auxRoles=Role.all
    @roles= Array.new

    @auxRoles.all.each do |role|

      @roles << [ role.typename, role.id  ]
    end

  end


  def new
    @employee = Employee.new
    @user = User.new
    @person = Person.new
    getRoles
  end

  def getRolesSaved
     @auxRoles = Role.all
    @roles = Array.new

    @auxRoles.all.each do |role|
      @roles << [ role.typename, role.id ]
    end
     #@roles.unshift(@employee.position)

  end
  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
    @person = Person.find(@employee.person_id)
    @user = User.find(@person.user_id)
    getRolesSaved
  end



  def create
      getRoles
      @person = Person.new(person_params)
      @employee = Employee.new(employee_params)
      @employee.agent_id = 1
      @person.identification_type= '1'
      @user = User.new(user_params)
      puts ",m,m,m,"
      puts params
      puts "kljkj"

    respond_to do |format|
      if @person.valid?
        if  @employee.valid?
                @user.username = @person.get_username
                @user.password = @person.get_password
                @user.role = Role.where(:typename => params[:employee][:position]).pluck(:id).first.to_i
               
                @user.active = true
             if @user.valid?

                  @user.save!
                  @person.user_id = @user.id
                  @person.save!
                  @employee.person_id = @person.id
                   @employee.save!
                  format.html { redirect_to @employee, notice: 'Empleado creado exitosamente' }
                  format.json { render :show, status: :created, location: @employee }

                else
                  format.html { render :new }
                  format.json { render json: user.errors, status: :unprocessable_entity}
              end

        else
          format.html { render :new }
          format.json { render json: @employee.errors, status: :unprocessable_entity}
        end
      else
        if  !@employee.valid?
          format.html { render :new }
          format.json { render json: @employee.errors, status: :unprocessable_entity}
        end
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity}
        end
    end

  end


  def update

        @employee = Employee.find(params[:id])
        @person = Person.find(@employee.person_id)
        @user = User.find(@person.user_id)
        getRolesSaved
            respond_to do |format|
        if @person.update_attributes(person_params)
          @user.username = @person.get_username
           @user.password = @person.get_password 
           @user.role = Role.where(:typename => params[:employee][:position]).pluck(:id).first.to_i
           user_params[:role] = Role.where(:typename => params[:employee][:position]).pluck(:id).first.to_i
            
          if  @employee.update_attributes(employee_params)

              if @user.update_attributes(user_params)

                 @employee.update_attributes(employee_params)
                 format.html { redirect_to @employee, notice: 'Empleado fue actualizado exitosamente' }
              else
                puts @user.password
                format.html { render :new }

              end
          else
          format.html { render :new }
          format.json { render json: @employee.errors, status: :unprocessable_entity}
        end
        else
          format.html { render :new }
        end
      end
  end



  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Empleado eliminado' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employees = Employee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:position, :profession)
  end


  def person_params
    params.require(:person).permit(:identification_number, 0, :first_name, :last_name, :phone_number, :country, :city, :address)
  end

  def user_params
     params.require(:user).permit(:role, :email, :active)
  end
end
