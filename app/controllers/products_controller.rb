class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    @products = Product.find(:all, :order => "id DESC", :limit => 8)
    @product = Product.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
   end
  end

  # GET /products/list
  def list
    @products = Product.find(:all, :order => "id DESC")

    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/list
  def help
    respond_to do |format|
      format.html # help.html.erb
      format.json { render json: @products }
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
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        File.open "#{Rails.root}/public/stl_files/#{@product.id}.stl", 'w' do |f|
          if params[:model][:type] == 'ochoko'
            f.write Ochoko.create @product.photo.path
          elsif params[:model][:type] == 'tokuri'
            f.write Tokkuri.create @product.photo.path
          end
        end
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /products
  # POST /products.json
  def democreate
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        File.open "#{Rails.root}/public/stl_files/#{@product.id}.stl", 'w' do |f|
            f.write Ochoko.create "#{Rails.root.to_s}/public/photos/original/missing.png"
        end
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if params[:product][:editkey] == @product.editkey
        if @deleteflag == true
          format.html { redirect_to '/'}
        end
        if @product.update_attributes(params[:product])
          File.open "#{Rails.root}/public/stl_files/#{@product.id}.stl", 'w' do |f|
            if params[:model][:type] == 'ochoko'
              f.write Ochoko.create @product.photo.path
            elsif params[:model][:type] == 'tokuri'
              f.write Tokkuri.create @product.photo.path
            end
          end
          format.html { redirect_to @product, notice: 'Product was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
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
