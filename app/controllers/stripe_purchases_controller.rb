class StripePurchasesController < ApplicationController
  def create
    @purchase = StripePurchase.new(email: stripe_params["stripeEmail"],
                               card_token: stripe_params["stripeToken"])
    raise "Please, check purchase errors" unless @purchase.valid?

    products = Purchase.array_of_products(params[:products])
    amount = products.map(&:cost).reduce(:+) * 100

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card  => params[:stripeToken]
    )

    purchase = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => amount.round,
      :description => products.map { |p| p.name.truncate(15) }.to_s,
      :currency    => params[:currency]
    )
    @purchase.save
    redirect_to @purchase, notice: 'Purchase was successfully created.'

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to :new
  end

  private
    def stripe_params
      params.permit :stripeEmail, :stripeToken, :stripeTokenType,
        :cost, :currency, products: []
    end
end
