# require 'openssl'
# require 'Base64'

class WelcomeController < ApplicationController

  def $client.get_all_tweets(user)
    options = {:count => 3, :include_rts => true}
    # user_timeline(user, options)
  end

  def index
    @newsletter = Newsletter.new
    # @instagram = Instagram.user_recent_media("2860181756" , {:count => 9})
    # @tweet_news = $client.get_all_tweets("NutritiousDe")
    @testimonials = Testimonial.all
    @blogs = Blog.order('created_at desc')
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

  def get_products
    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    response = requestd.item_search(
        query: {
            'SearchIndex' => 'Beauty',
            'Keywords' => 'Avalon Organics',
            'ResponseGroup' => "ItemAttributes,Images,Reviews"
        }
    )

    hashed_products = response.to_h

    @products = []

    hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
      p item
      product = OpenStruct.new
      product.name = item['ItemAttributes']['Title']
      product.url = item['DetailPageURL']
      product.price = item['ItemAttributes']['ListPrice']['FormattedPrice']
      product.image_url = item['LargeImage']['URL'] if item['LargeImage']
      product.link = item['ItemLinks']['ItemLink'][5]['URL']
      product.review = item['Reviews'] if item['Reviews']

      @products << product
    end

  end

  def blog
    @instagram = Instagram.user_recent_media("2860181756", {:count => 9})
    @tweet_news = $client.get_all_tweets("NutritiousDe")
    @newsletter = Newsletter.new
    #@blogs = Blog.order('created_at desc')
    #@blogs = Blog.paginate(:page => params[:page])
    @blogs = Blog.paginate(:page => params[:page], :per_page => 10).order('created_at desc')
  end

  def blog_details
    @instagram = Instagram.user_recent_media("2860181756", {:count => 9})
    @tweet_news = $client.get_all_tweets("NutritiousDe")
    @newsletter = Newsletter.new
    @blog = Blog.find(params[:id])
    @comment = Comment.new
    @total_comment = Comment.where(:blog_id => params[:id])
  end

  def add_comment
    @comment = Comment.new(comment_params)
    @comment.blog_id = params[:blog_id]
    #@comment.parent_id = params[:blog][:category_id]
    if @comment.save
      redirect_to welcome_blog_details_path(:id => params[:blog_id]), notice: "Comment added successfully!"
    else
      flash[:alert] = "#{@comment.errors.count} error prevented the comment from saving:"
      #render 'new'
    end
  end

  def about
    @newsletter = Newsletter.new
    @instagram = Instagram.user_recent_media("2860181756", {:count => 9})
    @tweet_news = $client.get_all_tweets("NutritiousDe")
  end

  def contact
    @newsletter = Newsletter.new
  end

  def package

  end

  def item_lookup
    @newsletter = Newsletter.new
    # @instagram = Instagram.user_recent_media("2860181756" , {:count => 9})
    # @tweet_news = $client.get_all_tweets("NutritiousDe")

    @categories = Category.all

    @category = Category.first

    @category = Category.where(:search_index => params[:s_i], :keyword => params[:key]).first if params[:s_i]

    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    response = requestd.item_lookup(
        query: {
            'ItemId' => params[:id],
            'RelationshipType' => 'NewerVersion',
            'ResponseGroup' => "ItemAttributes,Images,Reviews,RelatedItems,OfferListings"
        }
    )

    hashed_products = response.to_h

    @product = OpenStruct.new
    @product.name = hashed_products['ItemLookupResponse']['Items']['Item']['ItemAttributes']['Title']
    @product.price = hashed_products['ItemLookupResponse']['Items']['Item']['ItemAttributes']['ListPrice']['FormattedPrice'] if hashed_products['ItemLookupResponse']['Items']['Item']['ItemAttributes']['ListPrice']
    # @product.price = hashed_products['ItemLookupResponse']['Items']['Item']['Offers']['Offer']['OfferListing']['Price']['FormattedPrice']

    @product.url = hashed_products['ItemLookupResponse']['Items']['Item']['DetailPageURL']
    @product.feature = hashed_products['ItemLookupResponse']['Items']['Item']['ItemAttributes']['Feature']
    @product.image_url = hashed_products['ItemLookupResponse']['Items']['Item']['LargeImage']['URL'] if hashed_products['ItemLookupResponse']['Items']['Item']['LargeImage']
    @product.link = hashed_products['ItemLookupResponse']['Items']['Item']['ItemLinks']['ItemLink'][5]['URL']
    @product.review = hashed_products['ItemLookupResponse']['Items']['Item']['CustomerReviews']['IFrameURL']
    @product.offer_listing_id = hashed_products['ItemLookupResponse']['Items']['Item']['Offers']['Offer']['OfferListing']['OfferListingId']
    # binding.pry

  end

  def store
    @newsletter = Newsletter.new
    #@instagram = Instagram.user_recent_media("2860181756" , {:count => 9})
    # @tweet_news = $client.get_all_tweets("NutritiousDe")

    @categories = Category.all

    @category = Category.first

    @category = Category.where(:search_index => params[:s_i], :keyword => params[:key]).first if params[:s_i]

    @page = 1
    @page = params[:page] if params[:page]
    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    response = requestd.item_search(
        query: {
            'SearchIndex' => @category.search_index,
            'Keywords' => @category.keyword,
            'ItemPage' => @page,
            'ResponseGroup' => "ItemAttributes,Images,Reviews,ItemIds"
        }
    )

    hashed_products = response.to_h

    @total_pages = hashed_products['ItemSearchResponse']['Items']['TotalPages']

    # binding.pry
    @products = []

    hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
      product = OpenStruct.new
      product.name = item['ItemAttributes']['Title']
      product.price = item['ItemAttributes']['ListPrice']['FormattedPrice'] if item['ItemAttributes']['ListPrice']
      product.url = item['DetailPageURL']
      product.feature = item['ItemAttributes']['Feature']
      product.image_url = item['LargeImage']['URL'] if item['LargeImage']
      product.link = item['ItemLinks']['ItemLink'][5]['URL']
      product.review = item['Reviews'] if item['Reviews']
      product.id = item['ASIN']
      @products << product
    end


  end

  def store_details
    @categories = Category.all

    @category = Category.first

    @category = Category.where(:search_index => params[:s_i], :keyword => params[:key]).first if params[:s_i]

    @image = params['image']
    @url = params['url']
    @price = params['price']
    @feature = params['link']
    @name = params['name']
  end


  def package
    @newsletter = Newsletter.new
  end

  def comment_params
    params.require(:comment).permit(:name, :email, :message, :blog_id, :parent_id)
  end

  def generate_hmac_sign

  end

  # def cart_creation
  #
  #   @newsletter = Newsletter.new()
  #
  #
  #   # key = "your-secret-access-key"
  #   # data = "data you want signed"
  #   #
  #   # signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, data)).strip()
  #
  #
  #   requestd = Vacuum.new
  #
  #   requestd.configure(
  #       aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  #       aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  #       associate_tag: ENV['ASSOCIATE_TAG']
  #   )
  #
  #   @response = requestd.cart_create(
  #       query: {
  #           'HMAC' => '1cI2oZGsVSWjh3tk0+2yjkbYU11gPnqnjqOvBU/dTQk=',
  #           'Item.1.OfferListingId' => 'XGZdPS%2BLuLKIS78Yexly%2FcQFjYCmH0yUyTZ7HyDUwBpYovg28bbn0RYfuFAILE9fgxogRbhkYJbT%2BgTtGex1n%2BQYKvNJfSIyrgArcBNNlHXiN4LrOJ8gGWLadIQhajN1ofZkyTOwcMS%2BvboGIhJhpw%3D%3D',
  #           'Item.1.Quantity' => 2
  #       }
  #   )
  #
  #   # binding.pry
  #
  # end
  #
  # def cart_addition
  #   @newsletter = Newsletter.new()
  #
  #   requestd = Vacuum.new
  #
  #   requestd.configure(
  #       aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  #       aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  #       associate_tag: ENV['ASSOCIATE_TAG']
  #   )
  #
  #   @response = requestd.cart_add(
  #       query: {
  #           'CartId' => '179-1725620-9027834',
  #           'HMAC' => 'szsbYp77PVY8XUiX6TNJDJSc9Cw=',
  #           'Item.1.OfferListingId' => '4IDIUeHcgPz9W9IxD2qzEx%2BRY3r5sRnL2HAryBhHGSpipKvctoXyBoT8%2BMOL4xnW0nuK26NRjUXk9xrk1BnxeIxzfKLKCA%2B4m857Q%2BgVQElTuY5vkba5Qlt60h8XlEZyqk%2BVueOTWws%2Bc88cKh7CMtsq164wTV3Z',
  #           'Item.1.Quantity' => 1
  #       }
  #   )
  # end

  def cart_creation

    @newsletter = Newsletter.new()


    # key = "your-secret-access-key"
    # data = "data you want signed"
    #
    # signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, data)).strip()

    p "***************************************************"
    p "***************************************************"
    p params
    p "***************************************************"
    p "***************************************************"

    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    if current_user.carts.blank?

      response = requestd.cart_create(
          query: {
              'HMAC' => '1cI2oZGsVSWjh3tk0+2yjkbYU11gPnqnjqOvBU/dTQk=',
              'Item.1.OfferListingId' => params[:offer_id],
              'Item.1.Quantity' => params[:quantity]
          }
      )
      response = response.to_h
      p "***************************************"
      p "***************************************"
      p response.to_h
      p "***************************************"
      p "***************************************"
      cart_id = response['CartCreateResponse']['Cart']['CartId']
      hmac = response['CartCreateResponse']['Cart']['HMAC']
      purchase_url = response['CartCreateResponse']['Cart']['PurchaseURL']
      quantity = response['CartCreateResponse']['Cart']['Request']['CartCreateRequest']['Items']['Item']['Quantity']
      price = response['CartCreateResponse']['Cart']['SubTotal']['FormattedPrice']
      # cart_item_id = response['CartCreateResponse']['Cart']['CartItems']['CartItem']['CartItemId']
      # title = response['CartCreateResponse']['Cart']['CartItems']['CartItem']['Title']

      Cart.create(:user_id => current_user.id, :cart_id => cart_id, :hmac => hmac, :purchase_url => purchase_url, :quantity => quantity,
                  :price => price)
    else

      response = requestd.cart_add(
          query: {
              'CartId' => current_user.carts.first.cart_id,
              'HMAC' => current_user.carts.first.hmac,
              'Item.1.OfferListingId' => params[:offer_id],
              'Item.1.Quantity' => params[:quantity]
          }
      )
      response = response.to_h

      cart_id = response['CartAddResponse']['Cart']['CartId']
      hmac = response['CartAddResponse']['Cart']['HMAC']
      purchase_url = response['CartAddResponse']['Cart']['PurchaseURL']
      quantity = response['CartAddResponse']['Cart']['Request']['CartAddRequest']['Items']['Item']['Quantity']
      price = response['CartAddResponse']['Cart']['SubTotal']['FormattedPrice']
      Cart.create(:user_id => current_user.id, :cart_id => cart_id, :hmac => hmac, :purchase_url => purchase_url, :quantity => quantity,
                  :price => price)
    end

    respond_to do |format|
      format.json {
        render json: {:msg => 'OK'}
      }

    end
    # redirect_to cart_get_path
    # binding.pry

  end

  def cart_addition
    @newsletter = Newsletter.new()

    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    @response = requestd.cart_add(
        query: {
            'CartId' => '179-1725620-9027834',
            'HMAC' => 'szsbYp77PVY8XUiX6TNJDJSc9Cw=',
            'Item.1.OfferListingId' => '4IDIUeHcgPz9W9IxD2qzEx%2BRY3r5sRnL2HAryBhHGSpipKvctoXyBoT8%2BMOL4xnW0nuK26NRjUXk9xrk1BnxeIxzfKLKCA%2B4m857Q%2BgVQElTuY5vkba5Qlt60h8XlEZyqk%2BVueOTWws%2Bc88cKh7CMtsq164wTV3Z',
            'Item.1.Quantity' => 1
        }
    )
  end

  def cart_get
    @categories = Category.all

    cart = current_user.carts.first
    # p "+++++++++++++++++++++++++++++++++++++++++++++++++++"
    # p "+++++++++++++++++++++++++++++++++++++++++++++++++++"
    # p current_user
    # p current_user.carts
    # p "#####################################"
    # # p user.carts
    # p current_user.carts.first
    # p current_user.carts.first.cart_id
    # p "+++++++++++++++++++++++++++++++++++++++++++++++++++"
    # p "+++++++++++++++++++++++++++++++++++++++++++++++++++"

    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )
    # # user = current_user
    # p "***********************************"
    # p "***********************************"
    # p "***********************************"
    # p "***********************************"
    # p current_user
    # p current_user.carts
    # p "#####################################"
    # p user.carts
    # p current_user.carts.first
    # p current_user.carts.first.cart_id
    # p current_user.carts.first
    # p "***********************************"
    # p "***********************************"
    # p "***********************************"
    # p "***********************************"
    response = requestd.cart_get(
        query: {
            'CartId' => cart.cart_id,
            'HMAC' => cart.hmac
            # 'Item.1.OfferListingId' => '4IDIUeHcgPz9W9IxD2qzEx%2BRY3r5sRnL2HAryBhHGSpipKvctoXyBoT8%2BMOL4xnW0nuK26NRjUXk9xrk1BnxeIxzfKLKCA%2B4m857Q%2BgVQElTuY5vkba5Qlt60h8XlEZyqk%2BVueOTWws%2Bc88cKh7CMtsq164wTV3Z',
            # 'Item.1.Quantity' => 1
        }
    )

    response = response.to_h

    ar_check = response['CartGetResponse']['Cart']['CartItems']['CartItem']


    @purchase_url = response['CartGetResponse']['Cart']['PurchaseURL']
    if ar_check.is_a?(Array)
      @products = []

      response['CartGetResponse']['Cart']['CartItems']['CartItem'].each do |item|
        product = OpenStruct.new
        product.name = item['Title']
        product.quantity = item['Quantity']
        product.price = item['ItemTotal']['FormattedPrice']
        @products << product
      end

    else
      @product = OpenStruct.new
      @product.name = response['CartGetResponse']['Cart']['CartItems']['CartItem']['Title']
      @product.quantity = response['CartGetResponse']['Cart']['CartItems']['CartItem']['Quantity']
      @product.price = response['CartGetResponse']['Cart']['CartItems']['CartItem']['ItemTotal']['FormattedPrice']



    end

    respond_to do |format|
      format.html
    end
    # binding.pry
  end

end
