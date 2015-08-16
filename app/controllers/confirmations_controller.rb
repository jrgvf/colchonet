class ConfirmationsController < ApplicationController
  def show
  	user = User.find_by(id: params[:id])
  	if user.present? && user.confirmation_token == params[:token]
  		user.confirm!
  		redirect_to new_user_session_path, notice: I18n.t('confirmations.success')
  	elsif user.confirmed_at.present? && user.confirmation_token.blank?
  		redirect_to root_path, notice: I18n.t('confirmations.already_confirmed')
  	else
  		redirect_to root_path, notice: I18n.t('confirmations.invalid')
  	end
  end
end
