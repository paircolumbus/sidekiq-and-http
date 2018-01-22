require 'sidekiq'
require_relative 'http_connection'
Sidekiq::Logging.logger = nil

class GetRequestSender
  include Sidekiq::Worker
  sidekiq_options retry: 5
  sidekiq_retry_in { 0 }

  def perform(path, params={})
    query = path + "?"
    params.each do |k,v|
      query += "&#{k}=#{v}"
    end

    response = HttpConnection.get(query)
    puts JSON.parse(response)["message"]

    raise unless response.code == 200
  end
end
