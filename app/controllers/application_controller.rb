class ApplicationController < ActionController::Base
  before_action :require_login, except: [:top, :about]

  helper_method :current_role, :logged_in?, :accountant?, :viewer?

  private

  def current_role
    session[:role]
  end

  def logged_in?
    current_role.present?
  end

  def accountant?
    current_role == "accountant"
  end

  def viewer?
    current_role == "viewer"
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインしてください"
    end
  end
end