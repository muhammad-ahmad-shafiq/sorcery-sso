class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:email], params[:password], params[:remember])
        format.html do
          if params[:sso].present?
            redirect_to sso_discourse_path(sso: params[:sso], sig: params[:sig])
          else
            redirect_back_or_to(:users, notice: 'Login successfull.')
          end
        end
        format.xml { render xml: @user, status: :created, location: @user }
      else
        format.html { flash.now[:alert] = 'Login failed.'; render action: 'new' }
        format.xml { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    logout
    redirect_to(:users, notice: 'Logged out!')
  end
end
