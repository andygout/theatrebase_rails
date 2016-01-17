class Admin < ActiveRecord::Base

  self.primary_key = :user_id

  validates_presence_of :user

  belongs_to :user

end
