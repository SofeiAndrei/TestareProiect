class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  def new
    @user = User.new
  end

  def edit
    # shows view for the edit user page
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id]) # params fiind parametrul din url
    @microposts = @user.microposts.includes(image_attachment: :blob).paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = 'Please check your email to activate your account!'
      redirect_to root_url
      # echivalent cu redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Changes saved successfully!'
      redirect_to @user
      # echivalent cu redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  def index
    # @users = User.all  -> no pagination
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # Should be available only for admins
  def destroy
    user = User.find(params[:id]).destroy
    flash[:success] = 'Deleted user successfully'
    redirect_to users_url
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def activated_user
    unless activated?
      flash[:danger] = 'Please activate your account'
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
