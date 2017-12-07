require 'rest-client'
require 'json'

DOMAIN = "http://valapis.jp"
PATH = "/v1/bicycle_parkings.json"
parkings = []
offset = 1
station_code_list = []
parking_count_by_station = {}
capacity_by_station = {}

15.times do
  params = {
    fields: 'neighborStations.code,name,capacity',
    offset: offset
  }
  response = RestClient.get("#{DOMAIN}#{PATH}", params: params)

  response_body = response.body
  parkings += JSON.parse(response_body)['resultSet']['dataSet']['bicycleParkings']
  offset += 100
end


parkings.each do |parking|
  parking['neighborStations'].each do |station|
    station_code_list << station['code']
  end
end



File.open('station_code_list.js', 'w') do |f|
  f.puts("var stationCodeList = #{station_code_list.uniq.to_s}")
end

station_code_list.each do |code|
  if parking_count_by_station[code.to_s]
    parking_count_by_station[code.to_s] += 1
  else
    parking_count_by_station[code.to_s] = 1
  end
end

File.open('parking_count_by_station.js', 'w') do |f|
  f.puts("var parkingCountByStation = #{parking_count_by_station.to_json}")
end

station_code_list.uniq.each do |code|
  parkings.each do |parking|
    parking['neighborStations'].each do |station|
      if station['code'] == code
        if capacity_by_station[code.to_s]
          capacity_by_station[code.to_s] += parking['capacity']
        else
          capacity_by_station[code.to_s] = parking['capacity']
        end
      end
    end
  end
end


# parkings.each do |parking|
#   if capacity_by_station[parking['code'].to_s]
#     capacity_by_station[parking['code'].to_s] += parking['capacity']
#   else
#     capacity_by_station[parking['code'].to_s] = parking['capacity']
#   end
# end

File.open('capacity_by_station.js', 'w') do |f|
  f.puts("var capacityByStation = #{capacity_by_station.to_json}")
end
