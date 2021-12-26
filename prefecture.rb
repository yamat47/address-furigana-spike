# frozen_string_literal: true

class Prefecture
  attr_reader :code, :name, :name_kana, :name_romaji
  attr_accessor :cities

  def initialize(code:, name:, name_kana:, name_romaji:)
    @code = code
    @name = name
    @name_kana = name_kana
    @name_romaji = name_romaji
    @cities = []
  end
end
