class Room < ActiveRecord::Base
	extend FriendlyId

	has_many :reviews, dependent: :destroy
	has_many :reviewed_rooms, through: :reviews, source: :room
	belongs_to :user

	validates_presence_of :title, :slug

	friendly_id :title, use: [:slugged, :history]

	def complete_name
		"#{title}, #{location}"
	end

	def self.most_recent
		order(created_at: :desc)
	end

	def self.search(query)
		if query.present?
			where(['location LIKE :query OR title LIKE :query OR description LIKE :query',
				query: "%#{query}%"])
		else
			all
		end
	end

	def to_param
		"#{id}-#{title.parameterize}"
	end
end
