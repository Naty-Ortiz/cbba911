class StaticPagesController < ApplicationController

  def home
    if user_signed_in? && current_user.password_alteration == 0
      redirect_to '/users/edit'
    elsif user_signed_in? == false
      render 'static_pages/home', :layout => false
    end
  end

  def logout
    sign_out
    redirect_to '/'
  end

  def subregion_options
    render partial: 'subregion_select'
  end

  def error
    render 'static_pages/Error'
  end

end
