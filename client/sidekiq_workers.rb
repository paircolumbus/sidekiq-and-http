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
      parsed_response = JSON.parse(response)
      puts parsed_response['message']
      # The statement below is included because it was sending requests to
      # the server so fast that verify_ex_5! didn't say "Exercise 5 complete!"
      # This is because the process was completed when it entered the method.
      sleep 1
    end until response.code == 200
  end
end
