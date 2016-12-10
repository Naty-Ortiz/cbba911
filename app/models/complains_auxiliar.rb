class ComplainsAuxiliar < ActiveRecord::Base

  def self.search(search)
     where('delito LIKE :search OR descripcionHecho LIKE :search', search:"%#{search}%")
   end
end
