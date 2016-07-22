require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:my_user) {FactoryGirl.create(:user)}
  let(:my_wiki) {FactoryGirl.create(:wiki, user: my_user)}
  let(:my_private_wiki) {FactoryGirl.create(:wiki, user: my_user, private: true)}

  describe "GET index" do
    context "guest" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns my_wiki to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki])
      end
    end

    context "standard user" do
      login_user
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns my_wiki and my_private_wiki to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki, my_private_wiki])
      end
    end

    context "premium user" do
      login_user
      before do
        subject.current_user.premium!
      end
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns my_wiki and my_private_wiki to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki, my_private_wiki])
      end
    end

    context "admin" do
      login_user
      before do
        subject.current_user.admin!
      end
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns my_wiki and my_private_wiki to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki, my_private_wiki])
      end
    end
  end

  describe "GET new" do
    context "guest" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "user" do
      login_user
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "instantiates the @wiki" do
        get :new
        expect(:wiki).not_to be_nil
      end
    end
  end

  describe "GET show" do
    context "public wikis" do
      it "returns http success" do
        get :show, id: my_wiki.id
        expect(response).to have_http_status(:success)
      end

      it "renders the show template" do
        get :show, id: my_wiki.id
        expect(response).to render_template(:show)
      end

      it "assigns my_wiki to the @wiki" do
        get :show, id: my_wiki.id
        expect(assigns(:wiki)).to eq my_wiki
      end
    end

    context "private wikis" do
      context "guest" do
        it "returns http redirect" do
          get :show, id: my_private_wiki.id
          expect(response).to redirect_to(wikis_path)
        end
      end

      context "signed in user" do
        login_user
        it "returns http success" do
          get :show, id: my_private_wiki.id
          expect(response).to have_http_status(:success)
        end

        it "renders the show template" do
          get :show, id: my_private_wiki.id
          expect(response).to render_template(:show)
        end

        it "assigns my_wiki to the @wiki" do
          get :show, id: my_private_wiki.id
          expect(assigns(:wiki)).to eq my_private_wiki
        end
      end
    end
  end

  describe "POST create" do
    login_user
    it "increases the number of wikis by one" do
      expect{post :create, wiki: {title: "Wiki Title", body: "Wiki Body"}}.to change(Wiki, :count).by 1
    end

    it "makes the newly created wiki the last one" do
      post :create, wiki: {title: "Wiki Title", body: "Wiki Body"}
      expect(assigns(:wiki)).to eq Wiki.last
    end

    it "redirects to the wiki page" do
      post :create, wiki: {title: "Wiki Title", body: "Wiki Body"}
      expect(response).to redirect_to Wiki.last
    end
  end

  describe "GET edit" do
    login_user
    it "returns http success" do
      get :edit, id: my_wiki.id
      expect(response).to have_http_status(:success)
    end

    it "renders the edit view" do
      get :edit, id: my_wiki.id
      expect(response).to render_template(:edit)
    end

    it "assigns wiki to be updated to @wiki" do
      get :edit, id: my_wiki.id
      wiki_instance = assigns(:wiki)

      expect(wiki_instance.id).to eq my_wiki.id
      expect(wiki_instance.title).to eq my_wiki.title
      expect(wiki_instance.body).to eq my_wiki.body
    end
  end

  describe "PUT update" do
    login_user
    it "updates wiki with new attributes" do
      new_title = "Here is my new title"
      new_body = "Here is my new body"

      put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
      updated_wiki = assigns(:wiki)
      expect(updated_wiki.id).to eq my_wiki.id
      expect(updated_wiki.title).to eq new_title
      expect(updated_wiki.body).to eq new_body
    end

    it "redirects to the updated wiki page" do
      new_title = "Here is my new title"
      new_body = "Here is my new body"

      put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
      expect(response).to redirect_to(my_wiki)
    end
  end

  describe "DELETE destroy" do
    login_user
    it "deletes the wiki" do
      delete :destroy, id: my_wiki.id
      count = Wiki.where(id: my_wiki.id).size
      expect(count).to eq 0
    end

    it "redirects to the wiki index page" do
      delete :destroy, id: my_wiki.id
      expect(response).to redirect_to(wikis_path)
    end
  end
end