#!/usr/bin/env ruby
require 'faraday'
require 'json'
require 'pp'

## smart_contractの実行
node_url = ENV['NODE_URL']

req = Faraday::Connection.new(url: node_url) do |conn|
  conn.adapter Faraday.default_adapter
  conn.request :url_encoded
  conn.response :logger
  conn.headers['Content-Type'] = 'application/json'
  # Random.new_seedとかで作っちゃう方がいいかもね。
  conn.headers['x-kaleido-from'] = '0x81A74BDB06295729c4212e694B6fd43700f46433'
  conn.headers['Authorization'] = "Basic #{ENV['AUTH']}"
end

# Smart Contract実行
res = req.post("/instances/#{ENV['INSTANCE_PATH']}/set", { x: "123" }.to_json)
smart_contract =  JSON.parse(res.body)
pp smart_contract
smart_contract_id = smart_contract['id']

# レシート発行まで少し時間がかかる。
sleep 10

# レシート発行URL
receipt_req = Faraday::Connection.new(url: node_url) do |conn|
  conn.adapter Faraday.default_adapter
  conn.request :url_encoded
  conn.response :logger
  conn.headers['Authorization'] = "Basic #{ENV['AUTH']}"
end

receipt = receipt_req.get("/replies/#{smart_contract_id}")
pp JSON.parse(receipt.body)
