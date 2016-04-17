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
    # @instagram = Instagram.user_recent_media("2860181756", {:count => 9})
    # @tweet_news = $client.get_all_tweets("NutritiousDe")
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

    @categories = Category.all.order(:id)


    if params[:s_i]
      @category = Category.where(:search_index => params[:s_i], :keyword => params[:key]).first
      item_ids = @category.aws_product_lookups.map(&:product_id).join(",")
    else
      @category = Category.first
      item_ids = AwsProductLookup.limit(10).map(&:product_id).join(",")
    end

    Rails.logger.info "items ids............................#{item_ids}"
    @page = params[:page] || 1
    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )


    # response = requestd.item_search(
    #     query: {
    #         'SearchIndex' => @category.search_index,
    #         'Title' => @category.keyword,
    #         'ItemPage' => @page,
    #         'ResponseGroup' => "ItemAttributes,Images,Reviews,ItemIds,OfferListings,Offers",
    #         'Brand' => @category.brand
    #     }
    # )
    response = requestd.item_lookup(
      query: {
        'Condition' => 'All',
        'ItemId' => item_ids,
        'ResponseGroup' => "ItemAttributes,Images,Reviews,ItemIds,OfferListings,Offers",
        'Availability' => 'Available'
      }
    )


    hashed_products = response.to_h


    # @total_pages = hashed_products['ItemLookupResponse']['Items']['TotalPages']
    # binding.pry
    @products = []
    begin
      hashed_products['ItemLookupResponse']['Items']['Item'].each do |item|
        product = OpenStruct.new
        Rails.logger.info "item parsing.............................#{item.inspect}"
        product.name = item['ItemAttributes']['Title']
        # product.price = item['ItemAttributes']['ListPrice']['FormattedPrice'] if item['ItemAttributes']['ListPrice']
        begin
          if item['Offers']['Offer']
            product.price = item['Offers']['Offer']['OfferListing']['Price']['FormattedPrice']
          else
            product.price = item['ItemAttributes']['ListPrice']['FormattedPrice']
          end
        rescue
          product.price = nil
        end
        product.url = item['DetailPageURL']
        product.feature = item['ItemAttributes']['Feature']
        product.image_url = item['LargeImage']['URL'] if item['LargeImage']
        product.link = item['ItemLinks']['ItemLink'][5]['URL']
        product.review = item['Reviews'] if item['Reviews']
        product.id = item['ASIN']
        product.offer_listing_id = item['Offers']['Offer']['OfferListing']['OfferListingId'] if item['Offers']['Offer']
        # binding.pry
        @products << product
      end
    rescue Exception => e
      Rails.logger.info "Something went wrong............#{e.to_s}"
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
      cart_item_id = response['CartCreateResponse']['Cart']['CartItems']['CartItem']['CartItemId']
      # cart_item_id = response['CartCreateResponse']['Cart']['CartItems']['CartItem']['CartItemId']
      # title = response['CartCreateResponse']['Cart']['CartItems']['CartItem']['Title']

      Cart.create(:user_id => current_user.id, :cart_id => cart_id, :hmac => hmac, :purchase_url => purchase_url, :quantity => quantity,
                  :price => price, :cart_item_id => cart_item_id)
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
      p "***************************************"
      p "***************************************"
      p response.to_h
      p "***************************************"
      p "***************************************"
      # binding.pry
      cart_id = response['CartAddResponse']['Cart']['CartId']
      hmac = response['CartAddResponse']['Cart']['HMAC']
      purchase_url = response['CartAddResponse']['Cart']['PurchaseURL']
      quantity = response['CartAddResponse']['Cart']['Request']['CartAddRequest']['Items']['Item']['Quantity']
      price = response['CartAddResponse']['Cart']['CartItems']['CartItem'][0]['ItemTotal']['FormattedPrice']
      cart_item_id = response['CartAddResponse']['Cart']['CartItems']['CartItem'][0]['CartItemId']
      Cart.create(:user_id => current_user.id, :cart_id => cart_id, :hmac => hmac, :purchase_url => purchase_url, :quantity => quantity,
                  :price => price, :cart_item_id => cart_item_id)
      # binding.pry

    end
    # binding.pry

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

    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    response = requestd.cart_get(
        query: {
            'CartId' => cart.cart_id,
            'HMAC' => cart.hmac
            # 'Item.1.OfferListingId' => '4IDIUeHcgPz9W9IxD2qzEx%2BRY3r5sRnL2HAryBhHGSpipKvctoXyBoT8%2BMOL4xnW0nuK26NRjUXk9xrk1BnxeIxzfKLKCA%2B4m857Q%2BgVQElTuY5vkba5Qlt60h8XlEZyqk%2BVueOTWws%2Bc88cKh7CMtsq164wTV3Z',
            # 'Item.1.Quantity' => 1
        }
    )

    response = response.to_h
    p "*********************************************88"
    p "*********************************************88"
    p response
    p "*********************************************88"
    p "*********************************************88"
    # binding.pry
    ar_check = response['CartGetResponse']['Cart']['CartItems']['CartItem']


    @purchase_url = response['CartGetResponse']['Cart']['PurchaseURL']
    if ar_check.is_a?(Array)
      @products = []

      response['CartGetResponse']['Cart']['CartItems']['CartItem'].each do |item|
        product = OpenStruct.new
        product.name = item['Title']
        product.quantity = item['Quantity']
        product.price = item['ItemTotal']['FormattedPrice']
        product.id = item['CartItemId']
        # binding.pry

        @products << product
      end

    else
      @product = OpenStruct.new
      @product.name = response['CartGetResponse']['Cart']['CartItems']['CartItem']['Title']
      @product.quantity = response['CartGetResponse']['Cart']['CartItems']['CartItem']['Quantity']
      @product.price = response['CartGetResponse']['Cart']['CartItems']['CartItem']['ItemTotal']['FormattedPrice']
      @product.id = response['CartGetResponse']['Cart']['CartItems']['CartItem']['CartItemId']

# binding.pry

    end

    respond_to do |format|
      format.html
    end
    # binding.pry
  end

  def cart_remove
    @categories = Category.all

    cart = current_user.carts.first

    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )


    response = requestd.cart_modify(
        query: {
            'CartId' => current_user.carts.first.cart_id,
            'HMAC' => current_user.carts.first.hmac,
            'Item.1.CartItemId' => params[:id],
            'Item.1.Quantity' => 0
        }
    )

    response = response.to_h

    Cart.where(:cart_item_id => params[:id]).destroy_all



    respond_to do |format|
      if current_user.carts.blank?
        p"**************************************************88"
        p"**************************************************88"
        p"**************************************************88"
        p"**************************************************88"
        p"**************************************************88"
        p"**************************************************88"
        format.html { redirect_to store_path }
      else
        p "#######################################################"
        p "#######################################################"
        p "#######################################################"
        p "#######################################################"
        p "#######################################################"
        ip "#######################################################"
        format.html { redirect_to (:back) }
      end
    end

    p "***************************************************"
    p "***************************************************"
    p response
    p "***************************************************"
    p "***************************************************"
  end

end
