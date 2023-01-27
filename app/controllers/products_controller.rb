class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  before_action :set_user, :database_search
  before_action :set_booking, only: %i[show edit update destroy]
  before_action :set_product, only: %i[new create destroy]

  def accept
    @booking = Booking.find(params[:id])
    authorize @booking, :accept?
    @booking.update(status: "accepted")
    if @booking.product.update(status: true)
    redirect_to my_products_path, notice: "Réservation acceptée"
    else
      render :new
    end
  end

  def reject
    @booking = Booking.find(params[:id])
    authorize @booking, :reject?
    @booking.update(status: "rejected")
    @booking.product.update(status: false)
    redirect_to my_products_path, notice: "Réservation refusée"
  end

  def index
    #@products = Product.all
    @my_bookings = policy_scope(Booking)
    @my_bookings = Booking.where(user_id: current_user.id)
    @my_products_booked = current_user.products.map(&:bookings).flatten
    @markers = @products.geocoded.map do |product|
      {
        lng: product.longitude,
        lat: product.latitude,
        info_window_html: render_to_string(partial: "info_window", locals: { product: product }),
        marker_html: render_to_string(partial: "marker", locals: { product: product })
      }
    end
  end

  def new
    @product = Product.new
    authorize @product
  end

  def show
    @product = Product.find(params[:id])
    @booking = Booking.new
    @bookings = @product.bookings.where(status: "pending")
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = @user.id
    @product = current_user.products.build(product_params)
    authorize @product
    if @product.save
      flash[:notice] = "Product successfully listed for sale!"
      redirect_to @product
    else
      flash[:alert] = "Failed to list product for sale. Please try again."
      render :new
    end
  end

  def edit
    authorize @product
  end

  def update
    @product.update(product_params)
    @booking = @product.bookings.find(params[:booking_id])
    if params[:status] == false
      @booking.update(status: "accepted")
      flash[:notice] = "Booking request accepted!"
    elsif params[:status] == false
      @booking.update(status: "rejected")
      flash[:notice] = "Booking request rejected!"
    else
      flash[:alert] = "Invalid status. Please try again."
    end
    redirect_to @product
  end

  def destroy
    @product.destroy
    redirect_to my_products_path
    authorize @products
  end

  def my_products
    @products = current_user.products
    @bookings = @products.map {&:bookings}.flatten
    authorize @products
  end

  def search
    if params[:query].present?
      @products = Product.search_by_city_address(params[:query])
    else
      @products = Product.all
    end
    @count = @products.count
    @query = params[:query]

    @markers = @products.geocoded.map do |product|
      {
        lat: product.latitude,
        lng: product.longitude,
        info_window: render_to_string(partial: "info_window", locals: { product: product }),
        marker_html: render_to_string(partial: "marker", locals: {product: product})
      }
    end
    authorize @products
    authorize @markers
  end

  def reviews
    unless @product.reviews.empty?
      @reviews = @product.reviews
    end
  end

  def status
    @products = Product.where(status: params[:status])
  end

  def my_bookings
    @bookings = Booking.where(user: current_user)
  end

  # def my_bookings_as_owner
  #   @bookings = Booking.where(product: current_user.products)
  # end

  private

  def product_params
    params.require(:product).permit(:title, :description, :address, :city, :photo, :stock, :price, :latitude, :longitude, :status)
  end

  def set_product
    if Product.find_by(id: params[:id]).nil?
      redirect_to error_path
    else
      @product = Product.find(params[:id])
      authorize @product
    end
  end

  def set_user
    @user = current_user
  end

  def database_search
    @markers = Product.all
  end
end
