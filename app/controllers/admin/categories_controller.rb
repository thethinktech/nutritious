class Admin::CategoriesController < Admin::AdminController
  before_filter :set_category, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
    @categories = Category.order(id: :asc)
  end

  def new
    @category = Category.new
  end

  def show

  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category has been created!"
    else
      flash[:alert] = "#{@category.errors.count} error prevented the category from saving:"
      render 'new'
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category Updated!"
    else
      flash[:alert] = "Category could not be updated"
      render "edit"
    end


  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: 'Category was successfully destroyed.'
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :search_index, :keyword, :parent_id)
  end

end
