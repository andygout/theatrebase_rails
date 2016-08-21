class DateFormatValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    before_type_cast = "#{attribute}_before_type_cast"

    raw_value = record.send(before_type_cast) if record.respond_to?(before_type_cast.to_sym)
    raw_value ||= value

    return if raw_value.blank?

    error_msg = "#{record.class.human_attribute_name(attribute)} must be in a valid format or left empty"
    begin
      raw_value.to_date
    rescue
      record.errors.add(attribute, error_msg)
    else
      record.errors.add(attribute, error_msg) if value.blank?
    end
  end

end
