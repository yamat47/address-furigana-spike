# frozen_string_literal: true

def find_prefecture(address:)
  Struct.new(:name).new('北海道')
end

def find_city(prefecture:, address:)
  city_and_town = address.delete_prefix(prefecture.name)
  puts city_and_town

  Struct.new(:name).new('札幌市中央区')
end

require 'csv'

HEADER_MAP = {
  "都道府県コード" => :prefecture_code, "都道府県名" => :prefecture_name, "都道府県名カナ" => :prefecture_name_kana,
  "都道府県名ローマ字" => :prefecture_romaji, "市区町村コード" => :city_code, "市区町村名" => :city_name,
  "市区町村名カナ" => :city_name_kana, "市区町村名ローマ字" => :city_romaji, "大字町丁目名" => :town_name,
  "大字町丁目名カナ" => :town_name_kana, "大字町丁目名ローマ字" => :town_name_romaji, "小字・通称名" => :town_nickname,
  "緯度" => :latitude, "経度" => :longitude
}.freeze

data = CSV.table('./data/sample.csv', header_converters: proc { |h| HEADER_MAP[h] })

address = '北海道札幌市中央区南十条西二十丁目5-2'

prefecture = find_prefecture(address: address)
city = find_city(prefecture: prefecture, address: address)

puts prefecture.inspect
puts city.inspect

puts address.delete_prefix(prefecture.name).delete_prefix(city.name)
