class CollaboratorsController < ApplicationController
  
  before_action :set_wiki
  before_action :find_collab
  
  def destroy
    #authorize @wiki
    unless @wiki.owner == @collab.user
      if @collab.destroy
        flash[:notice] = "Collaborating user was sucessfully deleted"
        redirect_to current_user
      else
        flash[:alert] = "Sorry, collaborating user could not be deleted"
        redirect_to @wiki
      end
    else
      flash[:alert] = "As you are the owner of this wiki, you can not delete yourself!"
      redirect_to @wiki.owner
    end
  end

  private

  def find_collab
    @collab = @wiki.collaborators.find(params[:id])
  end

  def set_wiki
    @wiki = Wiki.find(params[:wiki_id])
  end
end