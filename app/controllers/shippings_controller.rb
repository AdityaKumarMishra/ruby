class ShippingsController < ApplicationController
  layout 'layouts/dashboard'
  before_action :authenticate_user!
  before_action :set_shipping, only: [:edit, :update, :destroy]

  def index
    @shippings = Shipping.all
    @outofstock = OutOfStock.first
    authorize @shippings
    respond_with(@shippings)
  end

  def new
    @shipping = Shipping.new
    authorize @shipping
    respond_with(@shipping)
  end

  def create
    @shipping = Shipping.new(shipping_params)
    authorize @shipping
    if @shipping.save
      redirect_to shippings_path, notice: 'Successfully created shipping price'
    else
      flash[:error] = 'Error while creating shipping price'
      render :new
    end
  end

  def edit
  end

  def update
    @shipping.update(shipping_params)
    redirect_to shippings_path, notice: 'Successfully updated shipping price.'
  end

  def destroy
    authorize(@shipping)
    @shipping.destroy
    redirect_to shippings_path, notice: 'Successfully deleted shipping price'
  end

  def update_out_of_stock
    out_of_stock = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:checked])
    if OutOfStock.first.present?
      OutOfStock.first.update(out_of_stock: out_of_stock, content: params[:val])
    else
      OutOfStock.create(out_of_stock: out_of_stock, content: params[:val])
    end
    redirect_to shippings_path
  end

  private

    def set_shipping
      @shipping = Shipping.find(params[:id])
      authorize @shipping
    end

    def shipping_params
      params.require(:shipping).permit(:country, :shipping_amount)
    end

end
