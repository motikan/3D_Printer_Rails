class ProductsController < ApplicationController
  include ProductsHelper

  # GET /products
  def index
    @products = Product.page(params[:page]).per(10).order("id DESC").limit(8)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /products/1
  def show
    @product = Product.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
   end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # POST /products
  def create
    @product = Product.create()
    @product.image =  params[:product][:image]
    @product.title = params[:product][:title]
    @product.deletekey = params[:product][:deletekey]

    respond_to do |format|
      if @product.save
        File.open "#{Rails.root}/public/stlFiles/#{@product.id}.stl", 'w' do |f|
          f.write Ochoko.create "#{Rails.root}/public" + @product.image.url.to_s
        end

        format.html { redirect_to @product, notice: 'Product was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # DELETE /products/1
  def destroy
    product = Product.find(params[:id])
    
    if product.deletekey == params[:code] then
      File.delete("#{Rails.root}/public" + product.image.url.to_s)
      File.delete("#{Rails.root}/public/stlFiles/#{product.id}.stl")
      product.destroy
      render :json => {'result' => true}
    else
      render :json => {'result' => false}
    end
  end

end
