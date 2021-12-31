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

prefectures = {}

data.each do |row|
  prefecture = prefectures.keys.detect { |prefecture| prefecture.code == row[:prefecture_code] }

  if prefecture.nil?
    prefecture = Prefecture.new(code: row[:prefecture_code], name: row[:prefecture_name],
                                name_kana: row[:prefecture_name_kana], name_romaji: row[:prefecture_romaji])

    prefectures[prefecture] = {}
  end

  city = prefectures[prefecture].keys.detect { |city| city.code == row[:city_code] }

  if city.nil?
    city = City.new(code: row[:city_code], prefecture_code: prefecture.code,
                    name: row[:city_name], name_kana: row[:city_name_kana], name_romaji: row[:city_romaji])

    prefectures[prefecture][city] = []
  end

  town = prefectures[prefecture][city].detect { |town| town.name == row[:town_name] }

  if town.nil?
    town = Town.new(name: row[:town_name], name_kana: row[:town_name_kana],
                    name_romaji: row[:town_name_romaji], nickname: row[:town_nickname],
                    latitude: row[:latitude], longitude: row[:longitude])

    prefectures[prefecture][city] << town
  end
end

CSV.open("parsed_data/prefectures.csv", "w") do |csv|
  csv << %w(code name name_kana name_romaji)
  prefectures.each_key { |prefecture| csv << [prefecture.formatted_code, prefecture.name, prefecture.name_kana, prefecture.name_romaji] }
end

prefectures.each do |prefecture, cities|
  CSV.open("parsed_data/#{prefecture.formatted_code}.csv", "w") do |csv|
    csv << %w(code prefecture_code name name_kana name_romaji)
    cities.each_key { |city| csv << [city.formatted_code, prefecture.formatted_code, city.name, city.name_kana, city.name_romaji] }
  end

  cities.each do |city, towns|
    CSV.open("parsed_data/#{prefecture.formatted_code}-#{city.formatted_code}.csv", 'w') do |csv|
      csv << %w[name name_kana name_romaji nickname latitude longitude]
      towns.each { |town| csv << [town.name, town.name_kana, town.name_romaji, town.nickname, town.latitude, town.longitude] }
    end
  end
end
