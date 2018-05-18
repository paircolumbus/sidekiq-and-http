require 'sidekiq'
require_relative 'http_connection'
require 'json'
Sidekiq::Logging.logger = nil

class GetRequestSender
  include Sidekiq::Worker
  sidekiq_options retry: 5
  sidekiq_retry_in { 0 }

  def perform(path, params={})
    # For exercise 3, replace this comment with code that
    # sends the request, parses the response, and uses `puts` to
    # print the message part of the response

      loop do
        response = HttpConnection.get(path, query: params)
        if response.code == 200
          parsed_json = JSON.parse(response)
          puts parsed_json["message"]
          break
        end
      end




    # For exercise 5, replace this comment with code that
    # retries the request if it fails
  end
end
