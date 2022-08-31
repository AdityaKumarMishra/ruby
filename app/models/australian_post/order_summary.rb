class OrderSummary
  def initialize(orderId)
    @orderId = orderId
    @accountNumber = '1007948742'
		@apikey = '7103d5e0-ec02-41d9-b69a-9e3cdc23e338'

    @apiURL = "https://digitalapi.auspost.com.au/testbed/shipping/v1/accounts"
      + @accountNumber + '/orders/' + @orderId + '/summary'
  end

  def summary
    result = RestClient::Request.new({ :method => :get, :url => @apiURL,
			headers: { 'authorization' => @apikey, 'content-type' => 'application/json', 'account-number' => @accountNumber }})
		JSON.parse(result.execute)
  end
end
