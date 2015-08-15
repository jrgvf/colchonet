class ConfirmationsController < ApplicationController
  def show
  	user = User.find_by(id: params[:id])
  	if user.present? && user.confirmation_token == params[:token]
  		user.confirm!
  		redirect_to user, notice: I18n.t('confirmations.success')
  	else
  		redirect_to root_path
  	end
  end
end
