class GenerateUrlValidator < ActiveModel::EachValidator

  include Shared::ParamsHelper

  def validate_each(record, attribute, value)
    url = generate_url(value)

    error_msg = "#{record.class.human_attribute_name(attribute)} does not create a valid URL"

    record.errors.add(attribute, error_msg) if url.length < 1
  end
end
