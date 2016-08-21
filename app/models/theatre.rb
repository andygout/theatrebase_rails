class Theatre < ActiveRecord::Base

  include Shared::ParamsHelper
  include Associations::Theatre
  include Validations::Theatre
  include WhitespaceStripable

end
