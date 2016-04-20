class SuperAdmin < ActiveRecord::Base

  include Validations::SuperAdmin
  include Associations::SuperAdmin

  self.primary_key = :user_id

end
