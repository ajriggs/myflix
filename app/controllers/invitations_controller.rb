class InvitationsController < ApplicationController
  before_action :require_login

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge! inviter: current_user)
    if @invitation.invitee_already_registered?
      flash.now[:error] = 'That person has already registered for myflix!'
      render :new
    elsif @invitation.save
      AppMailer.delay.invite_to_register(@invitation.id)
      flash[:notice] = 'Invite sent!'
      redirect_to home_path
    else
      flash.now[:error] = 'Oops. We found something wrong with your submission. Please revise and try again.'
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name, :email, :message)
  end
end
