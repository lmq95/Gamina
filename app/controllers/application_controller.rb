class ApplicationController < ActionController::Base
   before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender])
  end
  
  def after_sign_in_path_for(resource)
    if current_user
      flash[:notice]
      user_path(current_user.id)
    else
      flash[:notice]
      user_path(current_user.id)
    end
  end

  def after_sign_out_path_for(resource)
      flash[:notice] = "Signed out successfully."
      root_path
  end
  
end
