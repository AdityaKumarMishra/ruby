class CreateLabels
  def initialize(type, groups, trackingIds)
    @type = type
    @groups = groups
    @trackingIds = trackingIds
		@accountNumber = '1007948742'
		@apikey = '7103d5e0-ec02-41d9-b69a-9e3cdc23e338'

		# @urlPrefix = "digitalapi.auspost.com.au"
		@apiURL = "https://digitalapi.auspost.com.au/testbed/shipping/v1/labels"
  end

  def new_order
    groupHash = @groups.map do |g| {
        'group' => g.name,
        'layout' => g.layout,
        'branded' => g.branded,
        'left_offset' => g.left_offset,
        'top_offset' => g.top_offset
      }
    end
    queryPreferences = groupHash << { 'type' => @type }
    queryShipments = Hash.new(0)
    queryShipments = @trackingIds.map { |t_id| {'tracking_id' => t_id }}
    result = RestClient::Request.new({ :method => :post, :url => @apiURL, 'preferences' => queryPreferences, 'shipments' => queryShipments,
			headers: { 'authorization' => @apikey, 'content-type' => 'application/json', 'account-number' => @accountNumber }})
		JSON.parse(result.execute)
  end
end
