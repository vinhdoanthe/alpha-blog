class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  # before_action :require_user, except: [:new, :create]
  before_action :check_current_user, only: [:edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    #   debugger
    @user = User.new(user_params)
    if @user.save

      flash[:success] = "Welcome to the alpha blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully"
      redirect_to articles_path
    else
      render :edit
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end
  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_current_user
    if !logged_in? or (current_user != @user and !current_user.is_admin)
      flash[:danger] = "You do not have permission to perform this action"
      redirect_to root_path
    end
  end
end