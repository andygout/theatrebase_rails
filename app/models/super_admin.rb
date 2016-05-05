class SuperAdmin < ActiveRecord::Base

  include Associations::SuperAdmin
  include Validations::SuperAdmin

  self.primary_key = :user_id

end
