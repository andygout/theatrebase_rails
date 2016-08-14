class GenerateUrlValidator < ActiveModel::EachValidator

  include Shared::ParamsHelper

  MIN_LENGTH = 1
  MAX_LENGTH = 255
  UNIQUENESS_CLASSES = ['Theatre']

  def validate_each(record, attribute, value)
    url = generate_url(value)
    record_class = record.class
    readable_attr = record.class.human_attribute_name(attribute)

    if url.length < MIN_LENGTH
      msg = "#{readable_attr} creates a URL that is too short (must have at least #{MIN_LENGTH} valid character)"
      record.errors.add(attribute, msg)
    end

    if url.length > MAX_LENGTH
      msg = "#{readable_attr} creates a URL that is too long (must be #{MAX_LENGTH} characters or less)"
      record.errors.add(attribute, msg)
    end

    uniqueness_error =
      record.id &&
      UNIQUENESS_CLASSES.include?(record_class.to_s) &&
      record_class.where(url: url).where.not(id: record.id).limit(1).any?

    record.errors.add(attribute, "#{readable_attr} creates a URL that is already taken") if uniqueness_error
  end
end
