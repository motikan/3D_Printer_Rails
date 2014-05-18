require 'rubygems'
require 'RMagick'

class ProductsController < ApplicationController

  include ProductsHelper
<<<<<<< HEAD

=======
  
>>>>>>> d4afe528864652b050aa9607125a76c4720118d9
  # 例外ハンドル
  #rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  #rescue_from ActionController::UnknownAction, :with => :error_404
  #rescue_from ActionController::RoutingError, :with => :render_404
  #rescue_from Exception, :with => :render_500

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

  # GET /products/contact
  def contact
    respond_to do |format|
      format.html # contact.html.erb
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
    @product.editkey = ''
  end

  # POST /products
  # POST /products.json
def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save

        convertPng @product.photo.path.to_s
<<<<<<< HEAD
        
=======

>>>>>>> d4afe528864652b050aa9607125a76c4720118d9
        File.open "#{Rails.root}/public/stl_files/#{@product.id}.stl", 'w' do |f|
          if params[:model][:type] == 'ochoko'
            #f.write Ochoko.create @product.photo.path
            f.write Ochoko.create @base_image_path
          elsif params[:model][:type] == 'tokuri'
            #f.write Tokkuri.create @product.photo.path
            f.write Tokkuri.create @base_image_path
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
            File.open "#{Rails.root}/public/stl_files/#{@product.id}.stl", 'w' do |f|
              if params[:model][:type] == 'ochoko'
                f.write Ochoko.create @product.photo.path
              elsif params[:model][:type] == 'tokuri'
                f.write Tokkuri.create @product.photo.path
              end
            end
            format.html { redirect_to @product, notice: 'Product was successfully updated.' }
            format.json { head :no_content }
          end
        else
            format.html { render action: "edit" }
            format.json { render json: @product.errors, status: :unprocessable_entity }  
        end
      else
        @product.editkey = ''
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
=begin
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
=end

=begin
def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end

    render :template => "errors/error_404", :status => 404, :layout => 'application', :content_type => 'text/html'
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end

    render :template => "errors/error_500", :status => 500, :layout => 'application'
  end
=end
end
