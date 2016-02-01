class Admin::NewslettersController < Admin::AdminController	
  	layout 'admin'

  	def index
    	@newsletters = Newsletter.all
  	end

	def show

    end
end
