module RoomsHelper

	def belongs_to_user(room)
		user_signed_in? && is_current_user?(room.user)
	end

end
