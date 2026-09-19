class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # ログイン画面を表示するだけ
  end

  def create
    passcode = params[:passcode]

    if passcode == ENV["ACCOUNTANT_PASSCODE"]
      session[:role] = "accountant"
      redirect_to root_path, notice: "会計としてログインしました"
    elsif passcode == ENV["VIEWER_PASSCODE"]
      session[:role] = "viewer"
      redirect_to root_path, notice: "閲覧者としてログインしました"
    else
      flash.now[:alert] = "パスコードが違います"
      render :new
    end
  end

  def destroy
    session[:role] = nil
    redirect_to login_path, notice: "ログアウトしました"
  end
end