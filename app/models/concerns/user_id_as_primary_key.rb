module UserIdAsPrimaryKey

  extend ActiveSupport::Concern

  included do
    self.primary_key = :user_id
  end

end
