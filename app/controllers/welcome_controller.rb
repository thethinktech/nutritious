class WelcomeController < ApplicationController
  def index

  end

  def get_products
    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    #@key_index = ['Books','Beauty']
    #@key = ['Harry Potter','Avalon Organics']

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

    # binding.pry
  end

  def blog
    @blogs = Blog.all
  end

  def blog_details
    @blog = Blog.find(params[:id])
    @comment = Comment.new
    @total_comment = Comment.where(:blog_id => params[:id])
  end

  def add_comment
    @comment = Comment.new(comment_params)
    @comment.blog_id = params[:blog_id]
    #@comment.parent_id = params[:blog][:catgory_id]
    if @comment.save
      redirect_to welcome_blog_details_path(:id => params[:blog_id]), notice: "Comment added successfully!"
    else
      flash[:alert] = "#{@comment.errors.count} error prevented the comment from saving:"
      #render 'new'
    end
  end

  def about
    
  end

  def contact

  end

  def show
    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    response = requestd.item_lookup(
        query: {
            'SearchIndex' => 'Beauty',
            'Keywords' => 'Avalon Organics',
            'ResponseGroup' => "ItemAttributes,Images,Reviews"

        }
    )

    hashed_products = response.to_h

    @products = []

    hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
      product = OpenStruct.new
      product.name = item['ItemAttributes']['Title']
      product.price = item['ItemAttributes']['ListPrice']['FormattedPrice']
      product.url = item['DetailPageURL']
      product.image_url = item['LargeImage']['URL'] if item['LargeImage']
      product.link = item['ItemLinks']['ItemLink'][5]['URL']
      product.review = item['Reviews'] if item['Reviews']

      @products << product
    end
  end

  def store

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
      product = OpenStruct.new
      product.name = item['ItemAttributes']['Title']
      product.price = item['ItemAttributes']['ListPrice']['FormattedPrice']
      product.url = item['DetailPageURL']
      product.feature = item['ItemAttributes']['Feature']
      product.image_url = item['LargeImage']['URL'] if item['LargeImage']
      product.link = item['ItemLinks']['ItemLink'][5]['URL']
      product.review = item['Reviews'] if item['Reviews']

      @products << product
    end
  end

  def store_details
    @image = params['image']
    @url = params['url']
    @price = params['price']
    @feature = params['link']
    @name = params['name']
  end


  def package
    
  end

  def comment_params
      params.require(:comment).permit(:name, :email, :message, :blog_id, :parent_id)
  end


end
