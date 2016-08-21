class Suspension < ActiveRecord::Base

  include Associations::Status
  include Validations::Status
  include UserIdAsPrimaryKey

end
