module Shared::GetUserHelper

    private

    def get_user id
      @user = ['new', 'create'].include?(params[:action]) ? User.new : User.find(id)
    end

end
