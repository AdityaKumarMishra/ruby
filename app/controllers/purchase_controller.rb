class PurchaseController < ApplicationController
  before_action :authenticate_user!

  def product
    purchase_params = product_for_purchase_params
    dfdfd
    if purchase_params.has_key?(:products)
      purchase_ids = purchase_params.map(&:to_i).select{ |a| a > 0 }.join(', ')
      products = Product.where("id IN (#{purchase_ids})")
      if products.any?
          if Invoice.purchase current_user, products, nil
            redirect_to dashboard_courses_path, notice: 'Thank you for purchase'
          else
            redirect_to dashboard_courses_path, error: 'Error: Something went wrong'
          end
        return
      end
    end
    redirect_to dashboard_courses_path, error: 'No products'
  end

  def additional_features_form

  end

  private
  def product_for_purchase_params
    params.require(:products)
  end
end
