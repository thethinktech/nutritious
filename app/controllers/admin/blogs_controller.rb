class Admin::BlogsController < Admin::AdminController
  	layout 'admin'

  	def index
    	@blogs = Blog.order(id: :asc)
  	end

	def show

    end

    def new
    	@blog = Blog.new
      @categories = Category.all
  	end

  	def create
	    @blog = Blog.new(blog_params)
      @blog.user_id = params[:user_id]
      @blog.category_id = params[:blog][:category_id]
      @blog.image = params[:file]
	    if @blog.save
	      redirect_to admin_blogs_path, notice: "Blog added successfully!"
	    else
	      flash[:alert] = "#{@blog.errors.count} error prevented the blog from saving:"
	      render 'new'
	    end
    end


  	def blog_params
    	params.require(:blog).permit(:title, :decsription, :image, :user_id, :category_id)
  	end


end
