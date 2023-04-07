ActiveSupport::Notifications.subscribe(/rack_attack/) do |_name, _start, _finish, _request_id, payload|
  req = payload[:request]

  next unless [:throttle, :blacklist].include? req.env['rack.attack.match_type']

  match_data = req.env['rack.attack.match_data']
  Rails.logger.info("Rate limit hit (#{req.env['rack.attack.match_type']} - #{match_data[:limit].to_s}): #{req.ip} #{req.request_method} #{req.fullpath}")
end
