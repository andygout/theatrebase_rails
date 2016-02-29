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

end
