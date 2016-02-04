class PackagesController < ApplicationController
  
  def $client.get_all_tweets(user)
	options = {:count => 3, :include_rts => true}
	user_timeline(user, options)
  end
  def index
  	@newsletter = Newsletter.new
    @instagram = Instagram.user_recent_media("2860181756" , {:count => 9}) 
    @tweet_news = $client.get_all_tweets("NutritiousDe")
    @packages = Package.order('created_at desc').limit(6)
  end

  def add_newsletter
    @newsletter = Newsletter.new()
    @newsletter.email = params[:newsletter][:email]
    @newsletter.status = params[:status]
      if @newsletter.save
        redirect_to :back, notice: "Newsletter subscribe successfully!"
      else
        flash[:alert] = "#{@newsletter.errors.count} error prevented the newsletter from saving:"
        #render 'new'
      end
  end 

end
