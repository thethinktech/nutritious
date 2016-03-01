module Admin
  class AdminController < ActionController::Base
    before_filter :authenticate_user!, :check_signed_in, :authenticate_admin!

    layout "admin"

    private

    def check_signed_in
      unless user_signed_in?
        redirect_to user_sign_in_path
      end
    end

    def authenticate_admin!
      # email = params[:user][:email]
      # user = User.find_by_email email

      unless current_user.admin
        flash[:notice] = "You are not allowed to login!"
        redirect_to root_path
      end
    end

  end
end
