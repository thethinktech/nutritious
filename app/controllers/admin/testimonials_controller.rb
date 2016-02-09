class Admin::TestimonialsController < Admin::AdminController

	layout 'admin'

  def index
    @testimonials = Testimonial.order(id: :asc)
  end

  def show
    @testimonials = Testimonial.find(params[:id])
  end

  def new
    @testimonial = Testimonial.new
  end

  def create
    @testimonials = Testimonial.new(testimonial_params)
    @testimonials.user_id = params[:user_id]
    @testimonials.image = params[:file]
    if @testimonials.save
      redirect_to admin_testimonials_path, notice: "Testimonial added successfully!"
    else
      flash[:alert] = "#{@testimonial.errors.count} error prevented the package from saving:"
      render 'new'
    end
  end

  def destroy
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy
    respond_to do |format|
      format.html { redirect_to admin_testimonials_path, notice: 'Testimonial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def testimonial_params
    params.require(:testimonial).permit(:id, :user_id, :content, :name, :image, :city, :country)
  end

end
