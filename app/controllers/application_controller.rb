  require 'announcement.rb'
  require 'person.rb'
  require 'employee.rb'
  
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :home
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :html, :json
  helper_method :record_average
  helper_method :record_activity
def new_complain

    flash[:notice] = "Nuevo delito"

end
  def verify_password_change
    if user_signed_in?

      if current_user.password_alteration == false

        redirect_to '/users/edit'

      end
    end
  end
  def record_average 
   @crimes=  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where(:created_at => (DateTime.now-1).beginning_of_day..(DateTime.now-1).end_of_day).count
    puts "record aver"
    puts @crimes 
    puts"record"
     @dateBegin = Complain.order("complains.created_at ASC").last.created_at
    @dateFinal =Complain.order("complains.created_at ASC").last.created_at
    @totalDaysDB = Complain.group("date_trunc('day',complains.created_at)").where('  complains.created_at BETWEEN ? AND ? ', @dateBegin,@dateFinal).count.size

    @totalCrimesDayToday =  Complain.where( 'complains.created_at BETWEEN ? AND ? ' , @dateBegin,@dateBegin).joins(:crime).count
    @date =@dateBegin.change({ hour: 0, min: 0, sec: 1 })

    @dateFinal=@date.change({ hour: 23, min: 59, sec: 59 })
    @i= @totalDaysDB
    if @crimes>0

     @average = Average.new
      @average.name = "delitos"
      @average.created_at=@date

      @average.average= Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.created_at BETWEEN ? AND ? ', @date,@dateFinal).count

      puts  @average.average
      @average.save!

      
      @average2 = Average.new
      @average2.name = "prob"
      @average2.created_at=@date
      @avg=  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( 'complains.created_at BETWEEN ? AND ? ' , @dateBegin,@date).count

      @avg=@avg  /@i.to_f
      @average2.average=@avg.round(2) ;
      @average2.save!
     
     
    end
     
  end 
  def record_activity(note)
    @activity = ActivityLog.new
    if current_user !=nil
    @activity.user_id = current_user.id
    else
    @activity.user_id=0
    end
    @activity.note = note
    @activity.browser = request.env['HTTP_USER_AGENT']
    @activity.ip_address = request.env['REMOTE_ADDR']
    @activity.controller = controller_name
    @activity.action = action_name
    @activity.params = params.inspect
   # @activity.save!
end

  before_filter do
    Carmen.i18n_backend.locale = 'es'
  end



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :username, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :password, :password_confirmation, :current_password) }

  end
   helper_method :getAnnouncements

  def getAnnouncements
    @announcements = Hash.new
    @announcements[:personal] = Announcement.all.where( employee_id: current_user.person.employee, accepted: false, global: false )
    @announcements[:global] = Announcement.all.where( global: true , accepted: false )
    @announcements
  end

end
