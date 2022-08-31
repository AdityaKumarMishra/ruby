class UpdateShipment
  def initialize(shipment, trackingId)
		@shipment = shipment
    @trackingId = trackingId
		@accountNumber = '1007948742'
		@apikey = '7103d5e0-ec02-41d9-b69a-9e3cdc23e338'

		# @urlPrefix = "digitalapi.auspost.com.au"
		@apiURL = "https://digitalapi.auspost.com.au/testbed/shipping/v1/shipments"
      + @trackingId + '/items'
	end

  def update_items
    # queryParams = @shipment.each { |p| {
    #   'length' => p.length
    #   'height' => p.height
    #   'width' => p.width
    #   'weight' => p.weight
    #   'item_reference' => p.sku
    #   'product_id' => p.id
    #   'authority_to_leave' => false
    #   "partial_delivery_allowed" => true
    #   }
    # }
    result = RestClient::Request.new({ :method => :put, :url => @apiURL, 'items' => queryParams,
			headers: { 'authorization' => @apikey, 'content-type' => 'application/json', 'account-number' => @accountNumber }})
		JSON.parse(result.execute)
  end
end
