module Validations::Production

  extend ActiveSupport::Concern
  include Shared::ConstantsHelper

  included do
    validates :title,
      presence: true,
      length: { maximum: TEXT_MAX_LENGTH },
      generate_url: { if: proc { |p| p.title.present? && p.title.length <= TEXT_MAX_LENGTH } }

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
      length: { maximum: PRESS_DATE_WORDING_MAX_LENGTH }

    validates :dates_tbc_note,
      length: { maximum: DATES_TBC_NOTE_MAX_LENGTH }

    validate :dates_tbc_note_valid_presence, if: :dates_tbc_note

    validates :dates_note,
      length: { maximum: TEXT_MAX_LENGTH }

    validates :second_press_date,
      date_format: true, if: :press_date

    validate :second_press_date_valid, if: :second_press_date
  end

end
