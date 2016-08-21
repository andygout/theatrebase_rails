class SuperAdmin < ActiveRecord::Base

  include Associations::SuperAdmin
  include Validations::SuperAdmin
  include UserIdAsPrimaryKey

end
