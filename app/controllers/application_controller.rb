class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin!
    email = params[:user][:email]
    user = User.find_by_email email

    if user.present? && user.admin != true
      flash[:notice] = "You are not allowed to login!"
      redirect_to root_path
    end
  end

  protected
  def after_sign_out_path_for(resource)
    admin_root_path
  end
end
