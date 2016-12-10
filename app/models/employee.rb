class Employee < ActiveRecord::Base
  belongs_to :person, :dependent => :destroy
  has_many :announcements, :dependent => :destroy

  validates :position, presence: {:message => ' no debe dejarse en blanco.'}
  validates :profession, presence: {:message => ' no debe dejarse en blanco.'}

#  validates :agent_id, presence: {:message => ' no debe dejarse en blanco.'}
#  validates :agent_id, uniqueness: {:message => '  no debe repetirse.'}
  def self.search(search)
			where('first_name LIKE :search OR last_name LIKE :search', search:"%#{search}%")
		end
end
