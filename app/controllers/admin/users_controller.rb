class Admin::UsersController < Admin::AdminController
  layout 'admin'

  def index
    @users = User.all
  end
end
