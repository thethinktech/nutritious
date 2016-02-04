class Admin::PackagesController < Admin::AdminController

  layout 'admin'

  def index
    @packages = Package.order(id: :asc)
  end

  def show
    @package = Package.find(params[:id])
  end

  def new
    @package = Package.new
  end

  def create
    @package = Package.new(package_params)
    @package.user_id = params[:user_id]
    if @package.save
      redirect_to admin_packages_path, notice: "Package added successfully!"
    else
      flash[:alert] = "#{@package.errors.count} error prevented the package from saving:"
      render 'new'
    end
  end

  def destroy
    @package = Package.find(params[:id])
    @package.destroy
    respond_to do |format|
      format.html { redirect_to admin_packages_path, notice: 'Package was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def package_params
    params.require(:package).permit(:title, :start_date, :cost, :description, :user_id)
  end

end
