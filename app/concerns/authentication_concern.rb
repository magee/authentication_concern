module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @_current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def login!(user)
    session[:user_id] = user.id
  end

  def logout!
    @_current_user = nil
    session.delete(:user_id)
  end

  def logged_in?
    !current_user.nil?
  end

  def require_authentication!
    redirect_to root_path unless logged_in?
  end
end
