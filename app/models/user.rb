class User < ActiveRecord::Base

	scope :confirmed, -> { where.not(confirmed_at: nil) }

	EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
	
	has_many :rooms

	validates_presence_of :email, :full_name, :location
	validates_length_of :bio, minimum: 30, allow_blank: false
	validates_uniqueness_of :email

	has_secure_password

	before_create do |user|
		user.confirmation_token = SecureRandom.urlsafe_base64
	end

	def confirm!
		return if confirmed?
		self.confirmed_at = Time.current
		self.confirmation_token = ""
		save!
	end

	def confirmed?
		confirmed_at.present?
	end

	def self.authenticate(email, password)
		# using scope confirmed 
		confirmed.find_by(email: email).try(:authenticate, password)
		# OR \/
		# user = confirmed.find_by(email: email)
		# if user.present?
		# 	user.authenticate(password)
		# end
	end

	private

	# Essa validação pode ser representada da seguinte forma:
	# validates_format_of :email, with: EMAIL_REGEXP
	validate do
		errors.add(:email, :invalid) unless email.match(EMAIL_REGEXP)
	end

end
