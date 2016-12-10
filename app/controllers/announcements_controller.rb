class AnnouncementsController < ApplicationController

  before_action :set_announcement, only: [:show, :edit, :update, :destroy]
  before_action :verify_password_change
  before_action :verify_role

  # GET /announcements
  # GET /announcements.json
  def index
    if user_signed_in?
      if current_user.role == 3
        redirect_to root_url
      end
    end
  
    if params[:search]
      @announcements = Announcement.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    else
      @announcements = Announcement.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
    end

  end

  def employeeAnnouncements
    if params[:search]
      @announcements = Announcement.all.where( employee_id: current_user.person.employee)
      @announcements = @announcements + Announcement.all.where( global: true)
      @announcements = Announcement.search(params[:search]).order("created_at DESC")
    else
      @announcements = Announcement.all.where( employee_id: current_user.person.employee)
      @announcements = @announcements + Announcement.all.where( global: true)
    end

  end
  # GET /announcements/1
  # GET /announcements/1.json
  def show
    if not @announcement.global
      @employeeName = @announcement.employee.person.first_name + ' ' + @announcement.employee.person.last_name
    end
  end

  # get all the  names of the employees
  def getFullNameEmployees

    @employees = Array.new
    @EmployeesAndPeople= Employee.joins(person: :user).where(users: {role: [2,3,4,5]})

    @EmployeesAndPeople.all.each do |emp|
      @employees << [  emp.person.first_name + ' ' + emp.person.last_name, emp.id]
    end

  end

  def new
    if user_signed_in?
      if current_user.role != 1 && current_user.role != 4
        redirect_to root_url
      end
    end
    @announcement = Announcement.new
    getFullNameEmployees
  end

  # GET /announcements/1/edit
  def edit
    getFullNameEmployees
    if @announcement.global
      @announcement.employee_id=0
    end
  end


  # POST /announcements
  # POST /announcements.json
  def create
    getFullNameEmployees
    @announcement = Announcement.new(announcement_params)
    if @announcement.global
      @announcement.employee_id=0
    end
    @announcement.accepted = false

    #  @announcement.global = true
    respond_to do |format|

      if @announcement.save
        format.html { redirect_to @announcement, notice: 'Anuncio fue creado.' }
        format.json { render :show, status: :created, location: @announcement }
      else
        format.html { render :new }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /announcements/1
  # PATCH/PUT /announcements/1.json
  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to @announcement, notice: 'Anuncio fue actualizado.' }
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /announcements/1
  # DELETE /announcements/1.json
  def destroy
    @announcement.destroy
    respond_to do |format|
      format.html { redirect_to announcements_url, notice: 'Anuncio fue eliminado.' }
      format.json { head :no_content }
    end
  end

  def verify_role
    if user_signed_in?
      if current_user.role == 1
        [ :edit, :index, :new]
      elsif current_user.role == 5 || current_user.role == 2
        [:employeeAnnouncements]
      else
        redirect_to root_url
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def announcement_params
      params.require(:announcement).permit(:title, :content, :accepted, :global, :employee_id)
    end
end
