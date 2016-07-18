class ChargesController < ApplicationController
 before_action :authenticate_user!
 def create
   # Creates a Stripe Customer object, for associating
   # with the charge
   customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
   )
 
   # Where the real magic happens
   charge = Stripe::Charge.create(
     customer: customer.id, # Note -- this is NOT the user_id in your app
     amount: Amount.default,
     description: "Blocipedia Membership - #{current_user.email}",
     currency: 'usd'
   )
 
   flash[:notice] = "Thanks for upgrading your account, #{current_user.email}!"
   current_user.premium!
   redirect_to edit_user_registration_path(current_user)
 
   # Stripe will send back CardErrors, with friendly messages
   # when something goes wrong.
   # This `rescue block` catches and displays those errors.
   rescue Stripe::CardError => e
     flash[:alert] = e.message
     redirect_to new_charge_path
 end

 def new
   @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "Blocipedia membership - #{current_user.email}",
     amount: Amount.default
   }
 end
 
 def downgrade
   current_user.standard!
   flash[:notice] = "Your account has been downgraded to #{current_user.role}, #{current_user.email}!"
   redirect_to edit_user_registration_path(current_user)
 end
end
