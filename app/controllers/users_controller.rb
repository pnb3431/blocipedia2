class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def show
        @user = User.find(params[:id])
    end

    def update
        user = User.find(params[:id])
        user.assign_attributes(user_params)

        if user.save
            render json: user
        else
            render json: {}, status: :unprocessable_entity
        end
    end

  

    private

    def user_params
        params.require(:user).permit(:email)
    end
end
