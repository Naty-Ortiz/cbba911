class PatrolUnit < ActiveRecord::Base
  has_one :complain
  before_validation :uppercase
#	validates :name, :presence => {:message => ' no debe dejarse en blanco.'}
#	validates :name, length: {minimum:4, message:' debe tener como minimo cuatro caracteres'}
#	validates :name, uniqueness: {message: ' ya existe, no se debe duplicar'}

	validates :code, :presence => {:message => ' no debe dejarse en blanco.'}
	validates :code, uniqueness: {message: ' ya existe, no se debe duplicar'}


	def self.search(search)
		where("code ILIKE :search OR name ILIKE :search ", search:"%#{search}%")
	end


	protected
	def uppercase
	  self.code = self.code.upcase
	end
end
