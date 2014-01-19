class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    Amazon::Ecs.debug = true
    res = Amazon::Ecs.item_search("ruby", {:response_group => "Medium"})
    # puts res.items.inspect

    res.items.each do |item|
      item = item.to_s
      product = Product.new do |p|
        p.title = parseAttr(item, "Title")
        p.amazon_url = parseAttr(item, "DetailPageURL")
        p.medium_image_url = parseAttr(parseAttr(item, "MediumImage"), "URL")

        itemAttrs = parseAttr(item, "ItemAttributes")
        priceTag = parseAttr(itemAttrs, "ListPrice")
        if priceTag
          fprice = parseAttr(priceTag, "FormattedPrice")
          if fprice
            p.fprice = parseAttr(priceTag, "FormattedPrice")
            p.price = fprice[1, fprice.length].to_i
          else
            puts "FormattedPrice not found"
          end
        else  
          puts "ListPrice not found"
        end
        author = parseAttr(itemAttrs, "Author")
        if author
          p.author = author
        end
      end
    end
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    isbn = product_params[:isbn]
    res = Amazon::Ecs.item_lookup(isbn, { :response_group => "Medium"})

    item = res.items.first.to_s
    puts item

    amazon_url = parseAttr(item, "DetailPageURL")
    small_image_url = parseAttr(parseAttr(item, "SmallImage"), "URL")
    medium_image_url = parseAttr(parseAttr(item, "MediumImage"), "URL")

    title = parseAttr(item, "Title")
    author = parseAttr(item, "Author")
    if author
      category_id = 1;
    end
    fprice = parseAttr(item, "FormattedPrice")
    if fprice
      puts price = fprice[1, fprice.length].to_i
    end

    @product = Product.new(
      isbn: isbn,
      category_id: category_id,
      amazon_url: amazon_url,
      small_image_url: small_image_url,
      medium_image_url: medium_image_url,
      title: title,
      author: author,
      price: price,
      fprice: fprice
      )
    if @product.save
      flash[:notice] = "Successfully created product."
      redirect_to @product
    else
      render :action => 'new'
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:isbn, :title, :author, :publisher, :pages, :price, :category_id, :amazon_url, :small_image_url, :medium_image_url)
    end

    def parseAttr(item, attribute)
      matchIdx = (item =~ %r"<#{attribute}>")
      if matchIdx
        matchIdx += attribute.length + 2
      else
        return nil
      end
      matchEdx = item =~ %r"</#{attribute}>"
      puts matchIdx.to_s + ", " + matchEdx.to_s
      match = item[matchIdx, matchEdx - matchIdx]
      puts "#{attribute}: " + match
      match
    end
end
