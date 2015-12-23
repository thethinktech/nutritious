class SessionsController < Devise::SessionsController
  before_filter :authenticate_admin!, :only => :create

  def create
    super
  end

end