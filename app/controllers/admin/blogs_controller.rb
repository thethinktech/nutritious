class Admin::BlogsController < Admin::AdminController
 # before_filter :set_blog, only: [:show, :edit, :update, :destroy]
  	layout 'admin'

  	def index
    	@blogs = Blog.order('created_at desc')
  	end

	def show
    @blog = Blog.find(params[:id])
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

      def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to admin_blogs_path, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
    end

    def edit
      @blog = Blog.find(params[:id])
       @categories = Category.all
  end

      def update
       if @blog.update(blog_params)
      redirect_to admin_blog_path, notice: "Blog Updated!"
       else
      flash[:alert] = "Blog could not be updated"
      render "edit"
       end
       end

  	def blog_params
    	params.require(:blog).permit(:title, :decsription, :image, :user_id, :category_id)
  	end


end
