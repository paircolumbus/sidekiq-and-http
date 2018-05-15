require 'sidekiq'
require_relative 'http_connection'
Sidekiq::Logging.logger = nil

class GetRequestSender
  include Sidekiq::Worker
  sidekiq_options retry: 5
  sidekiq_retry_in { 0 }

  def perform(path, params={})
    loop do
      response = HttpConnection.get(path, query: params)
      parsed_response = JSON.parse(response)
      puts parsed_response['message']
      break if response.code == 200
    end
  end
end
