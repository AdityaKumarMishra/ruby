class OrdersMailerPreview < ActionMailer::Preview
  def promo_applied
    OrdersMailer.promo_applied(Promo.where("generated_from_id IS NOT NULL").first)
  end
end