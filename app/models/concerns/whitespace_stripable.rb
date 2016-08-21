module WhitespaceStripable

  extend ActiveSupport::Concern
  include Shared::ParamsHelper

  included do
    before_validation :strip_whitespace
  end

end
