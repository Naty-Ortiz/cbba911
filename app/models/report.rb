class Report < ActiveRecord::Base

  validates :title, presence: {:message => 'no debe dejarse en blanco.'}
  validates :title, uniqueness: {:message => 'se repitio, por favor utilizar otro.'}
  validates :description, presence: {:message => 'no debe dejarse en blanco.'}
  validates :antecedent, presence: {:message => 'no debe dejarse en blanco.'}
  validates :conclusion, presence: {:message => 'no debe dejarse en blanco.'}
  validates :recommendation, presence: {:message => 'no debe dejarse en blanco.'}
  validates :regulatory_framework, presence: {:message => 'no debe dejarse en blanco'}

    def self.search(search)
      where("title LIKE :search ", search:"%#{search}%")
    end
end
