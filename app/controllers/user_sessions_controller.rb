class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :except => [:destroy]

  def new
  end

  def create
    respond_to do |format|
      @user = User.first #login( params[:username], params[:password] )

      if @user
        format.html { redirect_back_or_to(:users, :notice => 'Login successfull.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { flash.now[:alert] = "Login failed."; render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    logout
    redirect_to(:users, :notice => 'Logged out!')
  end
end
