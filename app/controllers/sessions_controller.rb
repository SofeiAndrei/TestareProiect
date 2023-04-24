class SessionsController < ApplicationController
  def new
    # show the session view
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # echivalent cu user&.authenticate(params[:session][:password])
      if user.activated?
        # Successfull login
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # echivalent cu:
        # if params[:session][:remember_me] == '1'
        #   remember user
        # else
        #   forget user
        # end
        redirect_back_or user # echivalent cu user_url(user)
        # Aici daca e checked butonul de remember me ar trebui sa se faca un 'remember token'
      else
        flash[:danger] = 'Account not activated, check your email'
        redirect_to root_url
      end
    else
      # Unsuccessfull login
      flash.now[:danger] = 'Wrong password or email'
      render 'new' # iti arata tot view-ul de new ca sa mai incerci inca o data
    end
  end

  def destroy
    # Aici ar trebui sa se distruga si 'remember token-ul' daca exista
    log_out if logged_in?
    redirect_to root_path # te intoarce la home
  end
end