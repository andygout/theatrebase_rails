class GenerateUrlValidator < ActiveModel::EachValidator

  include Shared::ConstantsHelper
  include Shared::ParamsHelper

  TEXT_MIN_LENGTH = 1
  UNIQUENESS_CLASSES = ['Theatre']

  def readable_attr record, attribute
    record.class.human_attribute_name(attribute)
  end

  def uniqueness_msg record, attribute
    "#{readable_attr(record, attribute)} creates a URL that is already taken"
  end

  def validate_uniqueness url, record, attribute
    uniqueness_error =
      record.id &&
      UNIQUENESS_CLASSES.include?(record.class.to_s) &&
      record.class.where(url: url).where.not(id: record.id).limit(1).any?

    record.errors.add(attribute, uniqueness_msg(record, attribute)) if uniqueness_error
  end

  def length_msg length, record, attribute
    "#{readable_attr(record, attribute)} creates a URL that is too " + (length < TEXT_MIN_LENGTH ?
      "short (must have at least #{TEXT_MIN_LENGTH} valid character)" :
      "long (must be #{TEXT_MAX_LENGTH} characters or less)")
  end

  def validate_length length, record, attribute
    length_error = length < TEXT_MIN_LENGTH || length > TEXT_MAX_LENGTH
    record.errors.add(attribute, length_msg(length, record, attribute)) if length_error
  end

  def validate_each(record, attribute, value)
    url = generate_url(value)
    validate_length(url.length, record, attribute)
    validate_uniqueness(url, record, attribute)
  end

end
