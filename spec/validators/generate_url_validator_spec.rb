require 'rails_helper'

include Shared::ConstantsHelper

describe GenerateUrlValidator, type: :validator do
  [
    { class_name: 'Production', text_attr: :title },
    { class_name: 'Theatre', text_attr: :name }
  ].each do |m|
    context "#{m[:class_name]} URL validation" do
      with_model m[:class_name] do
        table { |t| t.string m[:text_attr] }
        model { validates m[:text_attr], generate_url: true }
      end

      it 'invalid if URL generated from string is less than one non-whitespace character' do
        expect(m[:class_name].constantize.new(m[:text_attr] => '\':/.,…?$%#').valid?).to be false
      end

      it 'invalid if URL generated from string exceeds length limit (while string itself is within limit: ß -> ss)' do
        expect(m[:class_name].constantize.new(m[:text_attr] => "#{'a' * (TEXT_MAX_LENGTH - 1)}ß").valid?).to be false
      end

      it 'valid if URL generated from string is within accepted minimum and maximum number of characters' do
        expect(m[:class_name].constantize.new(m[:text_attr] => 'hamlet').valid?).to be true
      end
    end
  end
end
