class BookingsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_user
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
    #@bookings = Booking.all
    @bookings = policy_scope(Booking)
    @my_bookings = policy_scope(Booking)
    @my_bookings = Booking.where(user_id: current_user.id)
    @my_products_booked = current_user.products.map(&:bookings).flatten
    @bookings = current_user.products.map(&:bookings).flatten.select { |b| b.status == "pending" }
  end

  def new
    @booking = Booking.new
    authorize @booking
  end

  def show
    authorize @booking
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user_id = @user.id
    @booking.product_id = @product.id
    @booking.total_price = ((@booking.end_date - @booking.start_date).to_i) * @product.price
    authorize @booking
    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  def edit
    authorize @booking
  end

  def update
    new_id = @booking.product_id
    @product = Product.find(new_id)
    @booking.update(booking_params)
    @booking.total_price = ((@booking.end_date - @booking.start_date).to_i) * @product.price
    authorize @booking
    if @booking.save
      redirect_to booking_path(@product, @booking)
    else
      render :edit
    end
  end

  def destroy
    authorize @booking
    @booking.destroy
    redirect_to bookings_path
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_user
    @user = current_user
  end


  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :status, :total_price)
  end
end
