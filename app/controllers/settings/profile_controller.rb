module Settings
  class ProfileController < ApplicationController
    before_action :authenticate_user!

    def update
      saved = if password_field_present?
                current_user.update_with_password(user_params)
              else
                current_user.update(filtered_user_params)
              end

      if saved
        redirect_to root_path, notice: 'Profile successfully updated.'
      else
        render :edit
      end
    end

    private

    def filtered_user_params
      user_params.except(:current_password, :password, :password_confirmation)
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name,
                                   :preferred_name,
                                   :email, :current_password,
                                   :password, :password_confirmation)
    end

    def password_field_present?
      user_params[:current_password].presence ||
        user_params[:password].presence ||
        user_params[:password_confirmation].presence
    end
  end
end
