class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_filter :set_newsletter
  before_filter :set_cart

  def authenticate_admin!
    email = params[:user][:email]
    user = User.find_by_email email

    if user.present? && user.admin != true
      # flash[:notice] = "You are not allowed to login!"
      redirect_to root_path
    end
  end

  def access_denied_to_visitors
    redirect_to root_path unless current_user
  end

  def allow_admin
    redirect_to root_path unless current_user.admin == true
  end

  def set_newsletter
    @newsletter = Newsletter.new
  end

  def set_cart
    if current_user && current_user.carts.count > 1
      price_array = current_user.carts.map(&:price)
      new_price_array = []
      price_array.each do |p|
        p.slice! "$"
        new_price_array << p
      end
      float_array = new_price_array.collect { |i| i.to_f }
      @total_cart_amount = float_array.inject(0){|sum,x| sum + x }
      @total_cart_amount = @total_cart_amount.round(2)
    elsif current_user && current_user.carts.count == 1
      cart_price = current_user.carts.first.price
      cart_price.slice! "$"
      @total_cart_amount = cart_price
      # @total_cart_amount = @total_cart_amount.round(2)
    elsif current_user && current_user.carts.blank?
      @total_cart_amount = "0.00"
    end

  end

  protected
  def after_sign_out_path_for(resource)
    admin_root_path
  end

  $client = Twitter::REST::Client.new do |config|
  config.consumer_key = 'F7Bs3Y3teUeYkMWRTV6LzU4g9'
  config.consumer_secret = 'WvnVNRPFdpsVfLpDlfvhGubbnRDoZJRUZQX3vOZ2Zi1n9OEIgB'
  config.access_token = '4859074155-HSphHp1y3Q2MEWKCpn2CKaLNEMxiblqZgvHSgM6'
  config.access_token_secret = 'pBDJ8GcAcuvU9L0uEqlMsA2t8OpLbfDwIz3DfqXf9bSCw'
end




end
