# Rack::Attack.throttle('req/ip', limit: 10, period: 2.minutes) do |req|
#   req.ip unless req.path.start_with?('/assets')
# end

# safelist a User-Agent
# Rack::Attack.safelist 'internal user agent' do |req|
#   req.user_agent == 'InternalUserAgent'
# end

BLOCKED_IPS = %w[148.251.54.157, 194.32.122.27]
Rack::Attack.blocklist "BLOCKED_IPS from sign in" do |req|
  BLOCKED_IPS.include?(req.ip)
end
