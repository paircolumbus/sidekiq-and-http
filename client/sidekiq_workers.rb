require 'sidekiq'
require_relative 'http_connection'
Sidekiq::Logging.logger = nil

class GetRequestSender
  include Sidekiq::Worker
  sidekiq_options retry: 5
  sidekiq_retry_in { 0 }

  def perform(path, params={})
    begin
      response = HttpConnection.get(path, query: params)
    end until response.code == 200

    puts JSON.parse(response)["message"]
  end
end
