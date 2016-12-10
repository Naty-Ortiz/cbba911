class Complainant < ActiveRecord::Base
	has_many :complains


  before_validation :uppercase
#	validates :name, :presence => {:message => ' no debe dejarse en blanco.'}
#	validates :name, uniqueness: {message: 'del proyecto ya existe, no se debe duplicar'}
	validates :ci, :presence => {:message => ' no debe dejarse en blanco.'}
	validates :name, :presence => {:message => ' no debe dejarse en blanco.'}
	 validates :last_name, :presence => {:message => ' no debe dejarse en blanco'}
	 
	# validates :latitude, numericality: { message: ' debe ser un numero' }
	# validates :longitude, :presence => {:message => ' Debe seleccionarse una ubicacion en el mapa'}
	# validates :longitude, numericality: { message: ' debe ser un numero' }

	def self.search(search)
		where("name LIKE :search ", search:"%#{search}%")
	end


protected
def uppercase
  self.name = self.name.upcase
end



end
