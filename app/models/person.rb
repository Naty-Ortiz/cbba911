class Person < ActiveRecord::Base

  has_one :employee
  belongs_to :user, :dependent => :destroy

  validates :identification_number, presence: {:message => 'no debe dejarse en blanco.'}
  validates :identification_number, uniqueness: {:message => 'ya fue registrado, no debe repetirse'}
  validates :identification_number, numericality: { only_integer: true, message: ' debe ser un numero' }
  validates :first_name, presence: {:message => 'no debe dejarse en blanco'}
  validates :first_name, length: {minimum: 3, message:'debe tener por lo menos 3 caractares'}
  validates :last_name, presence: {:message => 'no debe dejarse en blanco'}
  validates :last_name, length: {minimum: 4, message:'debe tener por lo menos 4 caractares'}
  validates :phone_number, presence: {:message => 'no debe dejarse en blanco'}
  validates :phone_number, numericality: { only_integer: true, message: ' debe ser un numero' }
  validates :country, presence: {:message => 'no debe dejarse en blanco'}
  validates :city, presence: {:message => 'no debe dejarse en blanco'}
  validates :address, presence: {:message => 'no debe dejarse en blanco'}

  def self.search(search)
    where('first_name ILIKE :search OR last_name ILIKE :search', search:"%#{search}%")
  end

  def get_username
    (identification_number+' '+first_name).squeeze(' ').split(' ').join('_').downcase
  end

  def get_password 
      (identification_number+' '+first_name).squeeze(' ').split(' ').join('_').downcase
  end

end
