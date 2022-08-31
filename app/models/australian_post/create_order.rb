class CreateOrder
  def initialize(trackingIds)
    @trackingIds = trackingIds
		@accountNumber = '1007948742'
		@apikey = '7103d5e0-ec02-41d9-b69a-9e3cdc23e338'

		# @urlPrefix = "digitalapi.auspost.com.au"
		@apiURL = "https://digitalapi.auspost.com.au/testbed/shipping/v1/orders"
  end

  def new_order
    queryParams = @trackingIds.each { |t_id| { 'shipment_id' => t_id }}
    result = RestClient::Request.new({ :method => :put, :url => @apiURL, 'shipments' => queryParams,
			headers: { 'authorization' => @apikey, 'content-type' => 'application/json', 'account-number' => @accountNumber }})
		JSON.parse(result.execute)
  end
end
