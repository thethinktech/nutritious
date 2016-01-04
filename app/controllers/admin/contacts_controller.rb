class Admin::ContactsController < Admin::AdminController
  before_filter :set_contact, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
    @contacts = Contact.order(id: :asc)
  end

  def new
    @contact = Contact.new
  end

  def show

  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to admin_contacts_path, notice: "Contact has been created!"
    else
      flash[:alert] = "#{@contact.errors.count} error prevented the contact from saving:"
      render 'new'
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to admin_contacts_path, notice: "Contact Updated!"
    else
      flash[:alert] = "Contact could not be updated"
      render "edit"
    end


  end

  def destroy
    @contact.destroy
    redirect_to admin_contacts_path, notice: 'Contact was successfully destroyed.'
  end

  private
  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number, :message)
  end

end
