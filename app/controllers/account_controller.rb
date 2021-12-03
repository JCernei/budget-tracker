require 'digest/md5'
require 'net/http'
require 'json'

class AccountController < ApplicationController
  before_action :authenticate_user!
  def index
    uri = URI("https://www.saltedge.com/api/v5/connections?customer_id=#{current_user.customer_id}")
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = 'application/json'
    req['Content-type'] = 'application/json'
    req['App-id'] = ENV.fetch('APP_ID')
    req['Secret'] = ENV.fetch('SECRET')
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    
    if res.code == '200'
      @connections = JSON.parse(res.body)['data']
      @accounts = fetch_accounts(@connections)
    end
  end

  def fetch_accounts(connections)
    accounts = []
    for connection in connections do
      uri = URI("https://www.saltedge.com/api/v5/accounts?connection_id=#{connection["id"]}")
      req = Net::HTTP::Get.new(uri)
      req['Accept'] = 'application/json'
      req['Content-type'] = 'application/json'
      req['App-id'] = ENV.fetch('APP_ID')
      req['Secret'] = ENV.fetch('SECRET')
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
      if res.code == '200'
        accounts += JSON.parse(res.body)['data']
      end
    end
    return accounts
  end

  def remove_connection
      uri = URI("https://www.saltedge.com/api/v5/connections/#{params['id']}")
      req = Net::HTTP::Delete.new(uri)
      req['Accept'] = 'application/json'
      req['Content-type'] = 'application/json'
      req['App-id'] = ENV.fetch('APP_ID')
      req['Secret'] = ENV.fetch('SECRET')
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
      if res.code == '200'
        redirect_to :action => 'index'
      end
  end

  def destroy
    redirect_to :action => 'index'
  end

  def create_session
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
    
    if res.code == '200'
      redirect_to JSON.parse(res.body)['data']['connect_url']
    end
  end
end
