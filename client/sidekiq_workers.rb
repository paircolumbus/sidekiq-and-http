require 'sidekiq'
require_relative 'http_connection'
Sidekiq::Logging.logger = nil

class GetRequestSender
  include Sidekiq::Worker
  sidekiq_options retry: 5
  sidekiq_retry_in { 0 }

  def perform(path, params={})
    path += '?' + params.map { |k,v| "#{k}=#{v}" }.join('&')
    response = HttpConnection.get(path)
    puts JSON.parse(response)['message']

    raise unless response.code == 200
  end
end
