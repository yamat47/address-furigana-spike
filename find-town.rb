# frozen_string_literal: true

require 'csv'

HEADER_MAP = {
  "都道府県コード" => :prefecture_code, "都道府県名" => :prefecture_name, "都道府県名カナ" => :prefecture_name_kana,
  "都道府県名ローマ字" => :prefecture_romaji, "市区町村コード" => :city_code, "市区町村名" => :city_name,
  "市区町村名カナ" => :city_name_kana, "市区町村名ローマ字" => :city_romaji, "大字町丁目名" => :town_name,
  "大字町丁目名カナ" => :town_name_kana, "大字町丁目名ローマ字" => :town_name_romaji, "小字・通称名" => :town_nickname,
  "緯度" => :latitude, "経度" => :longitude
}.freeze

data = CSV.table('./data/japanese-addresses.csv', header_converters: proc { |h| HEADER_MAP[h] })

puts data.detect { |row| row[:town_name_kana] == 'シモ 4' }.inspect
