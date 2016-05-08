module Validations::Production
  extend ActiveSupport::Concern

  included do
    validates :title,
      presence: true,
      length: { maximum: 255 }

    validates :first_date,
      presence: true

    validates :last_date,
      presence: true

    validates :press_date,
      date_format: true

    validate :first_last_date_chronological, if: [:first_date, :last_date]

    validate :press_date_chronological, if: [:first_date, :press_date, :last_date]

    validate :press_date_tbc_absence, if: :press_date

    validate :previews_only_absence, if: :press_date

    validates :press_date_wording,
      length: { maximum: 25 }

    validates :dates_tbc_note,
      length: { maximum: 15 }

    validate :dates_tbc_note_valid_presence, if: :dates_tbc_note

    validates :dates_note,
      length: { maximum: 255 }

    validates :second_press_date,
      date_format: true, if: :press_date

    validate :second_press_date_valid, if: :second_press_date
  end
end
