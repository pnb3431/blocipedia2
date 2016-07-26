class CollaboratorsController < ApplicationController
    
  def index
    @wiki = Wiki.find(params[:wiki_id])
    @collaborators = @wiki.collaborating_users
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    # Take username from search query and turn into user_id
    collaborator_ids = (User.where(username: params[:query])).ids
    collaborator_ids << @wiki.user_id unless collaborator_ids.empty?
    # not sure how to authorize using Pundit here. Needs work.
    if @wiki.collaborating_user_ids += collaborator_ids
      flash[:notice] = "Collaborators added successfully"
      redirect_to wiki_path(@wiki)
    else
      flash[:alert] = "There was an error adding collaborators to your wiki"
      redirect_to wiki_path(@wiki)
    end
  end

  def destroy
    @collaboration = Collaboration.find(params[:id])
    authorize @collaboration

    if @collaboration.destroy
      flash[:notice] = "Collaboration was successfully removed"
      redirect_to wiki_collaborations_path
    else
      flash[:alert] = "There was an error removing the collaborator. Please try again"
      redirect_to wiki_collaborations_path
    end
  end

end
