class WikisController < ApplicationController

  require "will_paginate/array"
  
  skip_before_action :authenticate_user!, only: [:show, :index]

  before_action :find_wiki, except: [:index, :new, :create]

  before_action :set_user, only: [:new, :create]

  def index
    @wikis = policy_scope(Wiki)
    @wikis = @wikis.paginate(page: params[:page], per_page: 10)
    #authorize @wikis
  end

  def new
    @wiki = current_user.wikis.new
    authorize @wiki
  end

  def show
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.users << current_user
    @wiki.user_id = current_user.id
    authorize @wiki
    if @wiki.save
      flash[:notice] = "wiki was sucessfully created"
      redirect_to current_user
    else
      flash[:alert] = "Sorry, wiki could not be created because #{@wiki.errors.messages}"
      redirect_to @user
    end
  end

  def edit
    authorize @wiki
  end

  def update
    authorize @wiki
    if @wiki.update(wiki_params)
      
      unless User.find_by(collab_params).nil?
        begin 
          if @wiki.private?
          
            @wiki.users << (User.find_by(collab_params))
          end
        rescue ActiveRecord::RecordInvalid
        #will write out the logic later
        end
      end
      
      flash[:notice] = "wiki was sucessfully updated"
      redirect_to @wiki
    else
      flash.now[:alert] = "Sorry, wiki could not be created because #{@wiki.errors.messages}"
      render 'edit'
    end
  end

  def destroy
    authorize @wiki
    if @wiki.destroy
    flash[:notice] = "wiki was sucessfully deleted"
      redirect_to @wiki.owner
    else
      flash[:alert] = "Sorry, wiki could not be deleted"
      redirect_to @wiki.owner
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def collab_params
    params.permit(:email)
  end

  def find_wiki
    @wiki = Wiki.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end