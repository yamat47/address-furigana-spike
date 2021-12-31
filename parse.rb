# frozen_string_literal: true

require 'csv'

require './prefecture'
require './city'
require './town'

HEADER_MAP = {
  "都道府県コード" => :prefecture_code, "都道府県名" => :prefecture_name, "都道府県名カナ" => :prefecture_name_kana,
  "都道府県名ローマ字" => :prefecture_romaji, "市区町村コード" => :city_code, "市区町村名" => :city_name,
  "市区町村名カナ" => :city_name_kana, "市区町村名ローマ字" => :city_romaji, "大字町丁目名" => :town_name,
  "大字町丁目名カナ" => :town_name_kana, "大字町丁目名ローマ字" => :town_name_romaji, "小字・通称名" => :town_nickname,
  "緯度" => :latitude, "経度" => :longitude
}.freeze

# data = CSV.table('./data/sample.csv', header_converters: proc { |h| HEADER_MAP[h] })
data = CSV.table('./data/japanese-addresses.csv', header_converters: proc { |h| HEADER_MAP[h] })

prefectures = []

data.each do |row|
  prefecture = prefectures.detect { |prefecture| prefecture.code == row[:prefecture_code] }

  if prefecture.nil?
    prefecture = Prefecture.new(code: row[:prefecture_code], name: row[:prefecture_name],
                                name_kana: row[:prefecture_name_kana], name_romaji: row[:prefecture_romaji])

    prefectures << prefecture
  end

  city = prefecture.cities.detect { |city| city.code == row[:city_code] }

  if city.nil?
    city = City.new(code: row[:city_code], name: row[:city_name],
                    name_kana: row[:city_name_kana], name_romaji: row[:city_romaji])

    prefecture.cities << city
  end

  town = city.towns.detect { |town| town.name == row[:town_name] }

  if town.nil?
    town = Town.new(name: row[:town_name], name_kana: row[:town_name_kana],
                    name_romaji: row[:town_name_romaji], nickname: row[:town_nickname],
                    latitude: row[:latitude], longitude: row[:longitude])

    city.towns << town
  end
end

CSV.open("parsed_data/prefectures.csv", "w") do |csv|
  csv << %w(code name name_kana name_romaji)
  prefectures.each { |prefecture| csv << [prefecture.formatted_code, prefecture.name, prefecture.name_kana, prefecture.name_romaji] }
end

prefectures.each do |prefecture|
  CSV.open("parsed_data/#{prefecture.formatted_code}.csv", "w") do |csv|
    csv << %w(code name name_kana name_romaji)
    prefecture.cities.each { |city| csv << [city.formatted_code, city.name, city.name_kana, city.name_romaji] }
  end

  prefecture.cities.each do |city|
    CSV.open("parsed_data/#{prefecture.formatted_code}-#{city.formatted_code}.csv", 'w') do |csv|
      csv << %w[name name_kana name_romaji nickname latitude longitude]
      city.towns.each { |town| csv << [town.name, town.name_kana, town.name_romaji, town.nickname, town.latitude, town.longitude] }
    end
  end
end
