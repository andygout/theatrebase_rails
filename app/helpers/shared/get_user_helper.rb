module Shared::GetUserHelper

    private

    def get_user id
      @user = User.find(id)
    end

end
