# frozen_string_literal: true

class City
  attr_reader :code, :name, :name_kana, :name_romaji

  def initialize(code:, name:, name_kana:, name_romaji:)
    @code = code
    @name = name
    @name_kana = name_kana
    @name_romaji = name_romaji
  end

  def formatted_code
    code.nil? ? 'UNKNOWN' : format("%05<number>d", number: code)
  end
end
