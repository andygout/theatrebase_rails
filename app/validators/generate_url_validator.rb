class GenerateUrlValidator < ActiveModel::EachValidator

  include Shared::ParamsHelper

  MIN_LENGTH = 1
  MAX_LENGTH = 255

  def validate_each(record, attribute, value)
    url = generate_url(value)

    readable_attr = record.class.human_attribute_name(attribute)

    if url.length < MIN_LENGTH
      msg = "#{readable_attr} creates a URL that is too short (must have at least #{MIN_LENGTH} valid character)"
      record.errors.add(attribute, msg)
    end

    if url.length > MAX_LENGTH
      msg = "#{readable_attr} creates a URL that is too long (must be #{MAX_LENGTH} characters or less)"
      record.errors.add(attribute, msg)
    end
  end
end
