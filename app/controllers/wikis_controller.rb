class WikisController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  
  
  def index
    @wikis = policy_scope(Wiki)
    
  end

  def show
    @wiki = get_wiki
  end

  def new
    @wiki = Wiki.new
  end
  
  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    if @wiki.save
      flash[:notice] = "Wiki saved successfully."
      redirect_to @wiki
    else
      flash[:alert] = "Unable to create wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = get_wiki
    authorize @wiki
  end
  
  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    if @wiki.update(wiki_params)
      flash[:notice] = "Your Wiki was successfully updated"
      redirect_to wiki_path
    else
      flash[:alert] = "There was an error updating you Wiki. Please try again."
      redirect_to edit_wiki_path
    end
    
  end
    
  def destroy
  
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "You Wiki was successfully deleted"
      redirect_to wikis_path
    else
      flash[:alert] = "There was an error deleting this Wiki. Please try again."
      redirect_to wiki_path
    end
  end
  
  private
  
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def get_wiki
    begin
      Wiki.visible_to(current_user).find(params[:id])
    rescue
      flash[:alert] = "Unable to find that wiki."
      redirect_to wikis_path
    end
  end
  
  
end
