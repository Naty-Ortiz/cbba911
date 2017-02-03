  require 'announcement.rb'
  require 'person.rb'
  require 'employee.rb'
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :home
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :html, :json
def new_complain

    flash[:notice] = "Nuevo delito"

end
  def verify_password_change
    if user_signed_in?

      if current_user.password_alteration == false

        #redirect_to '/users/edit'

      end
    end
  end
  def record_activity(note)
    @activity = ActivityLog.new
    @activity.user_id = current_user.id
    @activity.note = note
    @activity.browser = request.env['HTTP_USER_AGENT']
    @activity.ip_address = request.env['REMOTE_ADDR']
    @activity.controller = controller_name
    @activity.action = action_name
    @activity.params = params.inspect
    #@activity.save!
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
