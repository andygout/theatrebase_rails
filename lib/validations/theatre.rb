module Validations::Theatre

  extend ActiveSupport::Concern

  TEXT_MAX_LENGTH = 255

  included do
    validates :name,
      presence: true,
      length: { maximum: TEXT_MAX_LENGTH },
      generate_url: { if: proc { |t| t.name.present? && t.name.length <= TEXT_MAX_LENGTH } }
  end

end
