class WikisController < ApplicationController
  before_action :find_wiki, except: [:index, :new, :create]

  before_action :set_user, only: [:index, :new, :create]

  def index
    @wikis = current_user.wikis.all
  end

  def new
    @wiki = current_user.wikis.new
  end

  def show
   render partial: 'wiki', locals: {wiki: @wiki} 
  end

  def create
    @wiki = current_user.wikis.build(wiki_params)
    if @wiki.save
      flash[:notice] = "wiki was sucessfully created"
      redirect_to current_user
    else
      flash[:error] = "Sorry, wiki could not be created"
      redirect_to current_user
    end
  end

  def edit
    
  end

  def update
    if @wiki.update(wiki_params)
      flash[:notice] = "wiki was sucessfully updated"
      redirect_to current_user
    else
      flash[:error] = "Sorry, wiki could not be updated"
      render 'edit'
    end
  end

  def destroy
    if @wiki.destroy
    flash[:notice] = "wiki was sucessfully deleted"
      redirect_to current_user
    else
      flash[:error] = "Sorry, wiki could not be deleted"
      redirect_to current_user
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end

  def find_wiki
    @wiki = Wiki.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end