module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id]) # verificam daca este o sesiune temporara(adica folosim :session)
      @current_user ||= User.find_by(id: user_id)
      # echivalent cu:
      # if @current_user.nil?
      #   return @current_user = User.find_by(id: session[:user_id])
      # else
      #   return @current_user
      # end
    elsif (user_id = cookies.encrypted[:user_id]) # avem in cookie un session token
      # raise # The tests don't pass because we have the test in the helpers directory for sessions, if we didn't it would have passed
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    # Exista posibilitatea de pe 2 tab-uri sa dai pe logout si pe cealalta sa te logheze din ceva ce nu exista, adica eroare
    if logged_in?
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end
  end

  def remember(user)
    user.remember
    # cookies[:user_id] = user.id -> nu e safe, pune text-ul direct
    cookies.permanent.encrypted[:user_id] = user.id # il cripteaza
    # cookies[:remember_token] = { value: remember_token,
    #                              expires: 20.years.from_now.utc }
    # este echivalent cu exact ce scrie mai sus, pe 20 de ani
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Redirects to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end