require 'base64'

class CreateShipment

	def initialize(shipments, addressFrom)
		@addressFrom = addressFrom
		@shipments = shipments
		@accountNumber = '1007948742'
		@apikey = '7103d5e0-ec02-41d9-b69a-9e3cdc23e338'

		# @urlPrefix = "digitalapi.auspost.com.au"
		@apiURL = "https://digitalapi.auspost.com.au/testbed/shipping/v1/shipments"
	end

	def shipment_ids
		# queryParams = @shipments.each do |s| {
		# 									"shipment_reference" => "Shipment #{s.id}",
		# 									"customer_reference" => s.invoice.user,
		# 									"from" => {
		# 										'name' => @addressFrom.name,
		# 										'lines' => ["#{@addressFrom.number} #{@addressFrom.street_name} #{@addressFrom.street_type}"],
		# 										'suburb' => @addressFrom.suburb,
		# 										'postcode' => @addressFrom.postcode,
		# 										'state' => @addressFrom.state
		# 									},
		# 									'to' => {
		# 										'name' => "#{s.invoice.name}",
		# 										'business_name' => "#{s.invoice.name}",
		# 										'lines' => ["#{s.invoice.address.number}",
		# 											 "#{s.invoice.address.street_name} #{s.invoice.address.street_type}"
		# 										 ],
		# 										'suburb' => "#{s.invoice.address.suburb}",
		# 										'state' => "#{s.invoice.address.state}",
		# 										'postcode' => "#{s.invoice.address.postcode}",
		# 										'phone' => "#{s.invoice.phone}"
		# 									},
		# 									'items' => s.invoice.products.each { |p| {
		# 										'length' => p.length
		# 										'height' => p.height
		# 										'width' => p.width
		# 										'weight' => p.weight
		# 										'item_reference' => p.sku
		# 										'product_id' => p.id
		# 										'authority_to_leave' => false
		# 										"partial_delivery_allowed" => true
		# 											}
		# 										}
		# 									}
		# 								end
		result = RestClient::Request.new({ :method => :post, :url => @apiURL, 'shipments' => queryParams,
			headers: { 'authorization' => @apikey, 'content-type' => 'application/json', 'account-number' => @accountNumber }})
		JSON.parse(result.execute)
	end
end
