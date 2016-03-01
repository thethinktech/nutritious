class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_filter :access_denied_to_visitors, :except => [:new, :create]
  before_filter :allow_admin, :except => [:new, :create]

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

  def $client.get_all_tweets(user)
    options = {:count => 3, :include_rts => true}
    user_timeline(user, options)
  end

  # GET /contacts
  # GET /contacts.json
  def index
    @newsletter = Newsletter.new
    @contacts = Contact.all
    @instagram = Instagram.user_recent_media("2860181756" , {:count => 9}) 
    @tweet_news = $client.get_all_tweets("NutritiousDe")
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @newsletter = Newsletter.new()
    @contact = Contact.new
    # @instagram = Instagram.user_recent_media("2860181756" , {:count => 9})
    # @tweet_news = $client.get_all_tweets("NutritiousDe")
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to (:back), notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number, :message)
  end
end
