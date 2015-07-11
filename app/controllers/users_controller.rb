class UsersController < ApplicationController
  
  def index
    @users = User.all
    authorize @users
  end

  def show
    @user = User.find(params[:id])
    @wikis = @user.wikis.paginate(page: params[:page], per_page: 7)
    authorize @wikis
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    #stripe's work starts here
    token = params[:stripeToken]

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        :amount => 1500, # amount in cents, again
        :currency => "usd",
        :source => token,
        :description => "Premium membership fee"
      )
      @transaction = @user.transactions.create!(charge: charge.id)
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      edit_user_path(@user)
    end

    if @user.update(user_params)
      flash[:notice] = "You are now a premium member!"
      redirect_to @user
    else
      flash[:alert] = "Invalid user role"
      redirect_to edit_user_path(@user)
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    if @user.destroy
      flash[:notice] = "user was sucessfully deleted"
      redirect_to current_user
    else
      flash[:alert] = "Sorry, user could not be deleted"
      redirect_to @user
    end
  end

  def refund_user
    @user = User.find(params[:id]) || "deleted user"
    
    if check_refund?(charge_params, @user)
    
    @transaction = @user.transactions.find_by(charge_params)
    stripe_charge = @transaction.charge
    ch = Stripe::Charge.retrieve(stripe_charge)
    refund = ch.refunds.create
    judas = "deleted user"
    msg = "#{stripe_charge}_is already refunded!"
    @transaction.update(:charge => msg)
      if @user.update(:role => "standard")
        @user.make_wikis_public #makes this user's wikis public as a standard user
        flash[:notice] = "#{msg} for #{@user.name || judas}"
        redirect_to @user || current_user
      else
        flash[:alert] = "Refund error, try again"
        redirect_to @user || current_user
      end
    else
      flash[:alert] = "You supplied a wrong charge identification number. Refund was not made!"
      redirect_to @user || current_user
    end
  end


  private

  def user_params
    params.require(:user).permit(:role)
  end

  def charge_params
    params.permit(:charge)
  end

  def check_refund?(charge_string, user)
    !(charge_string.include? "refunded!")
    !user.transactions.find_by(charge_string).nil?
  end
end