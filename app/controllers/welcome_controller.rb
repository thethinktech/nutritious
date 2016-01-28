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

  end

  def blog_detail

  end

  def about
    
  end

  def contact

  end

  def item_lookup



    requestd = Vacuum.new

    requestd.configure(
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['ASSOCIATE_TAG']
    )

    response = requestd.item_lookup(
        query: {
            'SearchIndex' => params[:s_i],
            'Keywords' => params[:key],
            'ASIN' => params[:asin],
            'ResponseGroup' => "ItemAttributes,Images,Reviews"

        }
    )

    hashed_products = response.to_h

   # @products = []

      #hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
      #product = OpenStruct.new
      #product.name = item['ItemAttributes']['Title']
      #product.price = item['ItemAttributes']['ListPrice']['FormattedPrice'] if item['ItemAttributes']['ListPrice']
      #product.url = item['DetailPageURL']
      #product.image_url = item['LargeImage']['URL'] if item['LargeImage']
      #product.link = item['ItemLinks']['ItemLink'][5]['URL']
      #product.review = item['Reviews'] if item['Reviews']

      #@products << product
    #end

    # binding.pry

  end

  def store

    @categories = Category.all

    @category = Category.first

    @category = Category.where(:search_index => params[:s_i], :keyword => params[:key]).first if params[:s_i]

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
            'ResponseGroup' => "ItemAttributes,Images,Reviews,ItemIds"
        }
    )

    hashed_products = response.to_h

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
     # binding.pry
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


end
