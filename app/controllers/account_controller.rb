require 'digest/md5'
require 'net/http'
require 'json'

class AccountController < ApplicationController
  before_action :authenticate_user!
  def index
  end
 
  def create_session
    puts Time.now.utc.to_date.to_s
    uri = URI('https://www.saltedge.com/api/v5/connect_sessions/create')
    req = Net::HTTP::Post.new(uri)
    req['Accept'] = 'application/json'
    req['Content-type'] = 'application/json'
    req['App-id'] = ENV.fetch('APP_ID')
    req['Secret'] = ENV.fetch('SECRET')
    req.body = { data: {
                  customer_id: current_user.customer_id,
                  consent: {
                    scopes: [
                      "account_details",
                      "transactions_details"
                    ],
                    from_date: Time.now.utc.to_date.to_s
                  }, 
                  attempt: {return_to: url_for(action: 'index')},
                  theme: "dark"
                }
              }.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    puts JSON.parse(req.body)
    puts
    puts JSON.parse(res.body)

    if res.code == '200'
      redirect_to JSON.parse(res.body)['data']['connect_url']
    end
  end
end

