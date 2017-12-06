require 'dotenv'
require 'rest-client'

Dotenv.load

DOMAIN = 'https://api.ekispert.jp'
KEY = ENV['EKISPERT_KEY']


path = '/v1/json/station?'
params = {
  key: KEY
}

response = RestClient.get("#{DOMAIN}#{path}", { params: params })
puts response.body
