module ProductionsValidationsHelper

  def first_last_date_chronological
    if first_date > last_date
      errors.add(:first_date, 'Must be earlier than or equal to last date')
      errors.add(:last_date, 'Must be later than or equal to first date')
    end
  end

  def press_date_chronological
    errors.add(:press_date, 'Must be later than or equal to first date') if first_date > press_date
    errors.add(:press_date, 'Must be earlier than or equal to last date') if press_date > last_date
  end

  def press_date_checkbox_error_msg
    'Press date must be left empty if this box is checked'
  end

  def press_date_error_field_no_msg
    errors.add(:press_date, 'no_display')
  end

  def press_date_tbc_absence
    if press_date_tbc
      errors.add(:press_date_tbc, press_date_checkbox_error_msg)
      press_date_error_field_no_msg
    end
  end

  def previews_only_absence
    if previews_only
      errors.add(:previews_only, press_date_checkbox_error_msg)
      press_date_error_field_no_msg
    end
  end

  def second_press_date_valid
    if !press_date
      errors.add(:second_press_date, 'Must be left empty unless a valid press date is given')
    else
      errors.add(:second_press_date, 'Must be later than the press date') if second_press_date <= press_date
      errors.add(:second_press_date, 'Must be earlier than or equal to last date') if last_date && second_press_date > last_date
    end
  end

end
