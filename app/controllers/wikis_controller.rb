class WikisController < ApplicationController
  
  #before_action :authenticate_user!

  before_action :find_wiki, except: [:index, :new, :create]

  before_action :set_user, only: [:index, :new, :create]

  def index
    #@wikis = Wiki.all
    @wikis = @user.wikis.all
    authorize @wikis
    #render partial: 'wiki', collection: @wikis#, as: :wiki
  end

  def new
    @wiki = current_user.wikis.new
    authorize @wiki
  end

  def show
    authorize @wiki
    render partial: 'wiki', locals: {wiki: @wiki} 
  end

  def create
    @wiki = current_user.wikis.build(wiki_params)
    authorize @wiki
    if @wiki.save
      flash[:notice] = "wiki was sucessfully created"
      redirect_to current_user
    else
      flash[:alert] = "Sorry, wiki could not be created"
      redirect_to @user
    end
  end

  def edit
    authorize @wiki
  end

  def update
    authorize @wiki
    if @wiki.update(wiki_params)
      flash[:notice] = "wiki was sucessfully updated"
      redirect_to @wiki
    else
      flash.now[:alert] = "Sorry, wiki could not be updated"
      render 'edit'
    end
  end

  def destroy
    authorize @wiki
    if @wiki.destroy
    flash[:notice] = "wiki was sucessfully deleted"
      redirect_to @wiki.user
    else
      flash[:alert] = "Sorry, wiki could not be deleted"
      redirect_to @wiki.user
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def find_wiki
    @wiki = Wiki.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end