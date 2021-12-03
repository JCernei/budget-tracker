class TransactionsController < ApplicationController
  def index
    uri = URI("https://www.saltedge.com/api/v5/transactions?connection_id=#{params['connection_id']}&account_id=#{params['id']}")
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = 'application/json'
    req['Content-type'] = 'application/json'
    req['App-id'] = ENV.fetch('APP_ID')
    req['Secret'] = ENV.fetch('SECRET')
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    if res.code == '200'
      @transactions = JSON.parse(res.body)['data']
    end
  end
end
