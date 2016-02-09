class WelcomeController < ApplicationController
  
  def $client.get_all_tweets(user)
    options = {:count => 3, :include_rts => true}
    user_timeline(user, options)
  end

  def index
    @newsletter = Newsletter.new
    @instagram = Instagram.user_recent_media("2860181756" , {:count => 9}) 
    @tweet_news = $client.get_all_tweets("NutritiousDe")
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
    @instagram = Instagram.user_recent_media("2860181756" , {:count => 9}) 
    @tweet_news = $client.get_all_tweets("NutritiousDe")
    @newsletter = Newsletter.new
    #@blogs = Blog.order('created_at desc')
    #@blogs = Blog.paginate(:page => params[:page])
    @blogs = Blog.paginate(:page => params[:page], :per_page => 10).order('created_at desc')
  end

  def blog_details
    @instagram = Instagram.user_recent_media("2860181756" , {:count => 9}) 
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
    @instagram = Instagram.user_recent_media("2860181756" , {:count => 9}) 
    @tweet_news = $client.get_all_tweets("NutritiousDe")
  end

  def contact
    @newsletter = Newsletter.new
  end

  def package
    
  end

  def item_lookup
    @newsletter = Newsletter.new
    @instagram = Instagram.user_recent_media("2860181756" , {:count => 9}) 
    @tweet_news = $client.get_all_tweets("NutritiousDe")  

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
            'ResponseGroup' => "ItemAttributes,Images,Reviews,RelatedItems"
        }
    )

    hashed_products = response.to_h

    @product = OpenStruct.new
    @product.name = hashed_products['ItemLookupResponse']['Items']['Item']['ItemAttributes']['Title']
    @product.price = hashed_products['ItemLookupResponse']['Items']['Item']['ItemAttributes']['ListPrice']['FormattedPrice'] if hashed_products['ItemLookupResponse']['Items']['Item']['ItemAttributes']['ListPrice']
    @product.url = hashed_products['ItemLookupResponse']['Items']['Item']['DetailPageURL']
    @product.feature = hashed_products['ItemLookupResponse']['Items']['Item']['ItemAttributes']['Feature']
    @product.image_url = hashed_products['ItemLookupResponse']['Items']['Item']['LargeImage']['URL'] if hashed_products['ItemLookupResponse']['Items']['Item']['LargeImage']
    @product.link = hashed_products['ItemLookupResponse']['Items']['Item']['ItemLinks']['ItemLink'][5]['URL']
    @product.review = hashed_products['ItemLookupResponse']['Items']['Item']['CustomerReviews']['IFrameURL']

  end

  def store
    @newsletter = Newsletter.new
    @instagram = Instagram.user_recent_media("2860181756" , {:count => 9})
    @tweet_news = $client.get_all_tweets("NutritiousDe")

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


end
