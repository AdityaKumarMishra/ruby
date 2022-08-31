class PurchaseAddon < ApplicationRecord
belongs_to :enrolment
validates :features, presence: true

  def paypal_hash(return_url, cancel_url, features)

    price = BigDecimal.new("0")
    tax = BigDecimal.new("0")
    paypal_fee = BigDecimal.new("0")
    feature_items = []

    paypal_description = 'Addons:'

    features.each do |key,value|
      cost = BigDecimal.new(value['price']).round(2)
      price += cost
      paypal_description + ' ' + value['name'] + ','
      feature_items.push({
          name: value['name'],
          price: convert_to_currency(cost),
          currency: "AUD",
          quantity: 1})
    end

    paypal_description[0...-1]
    paypal_fee = (BigDecimal.new("0.02") * (BigDecimal.new("1.1")*price)).round(2)

    feature_items.push({
                           name: "PayPal fee",
                           price: convert_to_currency(paypal_fee),
                           currency: "AUD",
                           quantity: 1
                       })

    tax = (BigDecimal.new("0.1")*(price + paypal_fee)).round(2)

    paypal_total = price + paypal_fee + tax
    set_data(price,paypal_fee,tax)


    { intent: 'sale',

      payer: { payment_method: 'paypal' },

      redirect_urls: { return_url: return_url,
                       cancel_url: cancel_url },

      transactions: [{
                         item_list: {
                             items: feature_items},

                         amount: {
                             total: convert_to_currency(paypal_total),
                             currency: 'AUD',
                             details: {
                                 subtotal: convert_to_currency(price+paypal_fee),
                                 tax: convert_to_currency(tax) }},

                         description: paypal_description}]}
  end

  def paid?
    !self.paid_at.nil?
  end

  def paid!
    self.paid_at = Time.now
    self.date_activated = Time.now
    self.activate_features
    self.save!
  end

  def feature_names
    out = ''

    JSON.parse(self.features).each do |key,value|
     out += value['name'] +','
    end
    out[0...-1]
  end

  # def activate_features
  #   JSON.parse(self.features).each do |key,value|
  #     fe = Enrolment.find_by_id(self.enrolment_id).feature_enrolments.find_by(feature_id: key.to_i)
  #     if fe.options.nil?
  #       fe.options = {'tutor_time' => value['tutor_time']}.as_json if fe.feature.private_tutoring? and fe.active
  #       fe.options = {'essay_num' => value['essay_num']}.as_json if fe.feature.essay? and fe.active
  #     else
  #       fe.update_options('tutor_time', eval(fe.options)['tutor_time'] + value['tutor_time']) if fe.feature.private_tutoring? and fe.active if eval(fe.options)["tutor_time"].present?
  #       fe.update_options('tutor_time', eval(fe.options)[:tutor_time] + value['tutor_time']) if fe.feature.private_tutoring? and fe.active if eval(fe.options)[:tutor_time].present?
  #       fe.update_options('essay_num', eval(fe.options)['essay_num'] + value['essay_num']) if fe.feature.essay? and fe.active
  #     end
  #     fe.active = true
  #     fe.save!
  #   end
  # end

  private


  def convert_to_currency(number)
    (number.to_s('F')+"0")[ /.*\..{2}/ ]
  end

  def set_data(price,paypal_fee,tax)
    self.subtotal = price
    self.paypal_fee = paypal_fee
    self.gst = tax
  end


end
