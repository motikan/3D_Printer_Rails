class ProductsController < ApplicationController
    include ProductsHelper

  # GET /products
  # GET /products.json
  def index
    @products = Product.find(:all, :order => "id DESC", :limit => 8)
    @product = Product.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
   end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @product.editkey = ''
  end

  # POST /products
  # POST /products.json
  def create
    product = Product.create(image: params[:product][:image])
    product.title = params[:product][:title]

    respond_to do |format|
      if product.save!
        puts product.image.url

        File.open "#{Rails.root}/public/stlFiles/#{product.id}.stl", 'w' do |f|
            f.write Ochoko.create "#{Rails.root}/public" + product.image.url.to_s
        end

        format.html { redirect_to product, notice: 'Product was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end


  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if params[:product][:editkey] == @product.editkey #エディットキーと一致しているか
        if @product.update_attributes(params[:product])
          if @product.deleteflag == 1
            @product.destroy
            format.html { redirect_to '/'}
          else
            File.open "#{Rails.root}/public/stlFiles/#{@product.id}.stl", 'w' do |f|
              f.write Ochoko.create @product.photo.path
            end
            format.html { redirect_to @product, notice: 'Product was successfully updated.' }
          end
        else
            format.html { render action: "edit" }
        end
      else
        @product.editkey = ''
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

end
