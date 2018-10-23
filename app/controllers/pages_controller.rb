class PagesController < ApplicationController
    before_action :authenticate_user!
    
    def home
        @user = current_user
    end

    def process_payment
        
        # Amount in cents
        @amount = 1500

       customer = Stripe::Customer.retrieve(current_user.customer_id)
       customer.source = params[:stripeToken]
       customer.save

        charge = Stripe::Charge.create(
            :customer    => current_user.customer_id,
            :amount      => @amount,
            :description => 'Rails Stripe customer',
            :currency    => 'usd'
        )

        redirect_to "/"

        rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to "/"
    end
end
