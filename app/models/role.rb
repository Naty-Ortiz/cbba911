class Role < ActiveRecord::Base
 before_validation :uppercase
  validates :typename, :uniqueness => {:message => 'ya fue registrado, no debe repetirse'}
  validates :typename, :presence => {:message => 'no debe dejarse en blanco'}
 
protected
  def uppercase
    self.typename = self.typename.upcase
  end
  
end
