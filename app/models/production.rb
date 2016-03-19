class Production < ActiveRecord::Base

  include ActiveModel::Validations
  include ProductionsValidationsHelper

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
    length: { maximum: 255 }

  validates :dates_tbc_note,
    length: { maximum: 255 }

  validates :dates_note,
    length: { maximum: 255 }

  validates :second_press_date,
    date_format: true, if: :press_date

  validate :second_press_date_valid, if: :second_press_date

  belongs_to :creator,
    class_name: :User,
    foreign_key: :creator_id

  belongs_to :updater,
    class_name: :User,
    foreign_key: :updater_id

end
