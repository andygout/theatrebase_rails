class Production < ActiveRecord::Base

  validates :title,
    presence: true,
    length: { maximum: 255 }

end
