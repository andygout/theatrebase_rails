require 'rails_helper'

MAX_LENGTH ||= 255

describe GenerateUrlValidator, type: :validator do
  context 'URL validation' do
    with_model :production do
      table { |t| t.string :title }
      model { validates :title, generate_url: true }
    end

    it 'invalid if URL generated from string is less than one non-whitespace character' do
      expect(Production.new(title: '\':/.,…?$%#').valid?).to be false
    end

    it 'invalid if URL generated from string exceeds length limit (while string itself is within limit: ß -> ss)' do
      expect(Production.new(title: "#{'a' * (MAX_LENGTH - 1)}ß").valid?).to be false
    end

    it 'valid if URL generated from string is within accepted minimum and maximum number of characters' do
      expect(Production.new(title: 'hamlet').valid?).to be true
    end
  end
end
