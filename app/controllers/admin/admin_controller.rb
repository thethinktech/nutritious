module Admin
  class AdminController < ActionController::Base
    before_filter :authenticate_user!, :check_signed_in

    layout "admin"

    private

    def check_signed_in
      unless user_signed_in?
        redirect_to user_sign_in_path
      end
    end

  end
end
