class Announcement < ActiveRecord::Base
  belongs_to :employee

  validates :title, length: {minimum: 3, message:'debe tener por lo menos 3 caractares'}
  validates :title, uniqueness: {message: ' ya existe, no se debe duplicar'}
  validates :title, :presence  => {:message => 'no debe dejarse en blanco'}
  validates :content, length: {minimum: 4, message:'debe tener por lo menos 14 caractares'}
  validates :content, :presence => {:message => 'no debe dejarse en blanco'}

   def self.search(search)
			where('title LIKE :search OR content LIKE :search', search:"%#{search}%")
		end

end
