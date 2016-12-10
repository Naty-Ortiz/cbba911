class User < ActiveRecord::Base
  before_save :verify_password

  has_one :person
  has_many :complains

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login

  validates :username, :uniqueness => {:message => 'ya fue registrado, no debe repetirse'}

  validates :password,:format => {:multiline=> true, :with => /^(?=.*[a-zA-Z])(?=.*[[:^alnum:]])(?=.*[0-9]).{8,}$/, :message => 'debe tener minimamente ocho caracteres, una  mayuscula, numero y caracter especail'}        # Must contain 8 or more characters

  def self.find_for_database_authentication(conditions={})
    find_by(username: conditions[:login])
  end

  def self.search(search)
    where("username LIKE ?", "%#{search}%")
  end

  search = 'admin'
  User.where('username LIKE ?', "#{search}[0-9][0-9][0-9][0-9]")

  def active_for_authentication?

      super and self.active?
    end

  def verify_password
    if changed.include?('encrypted_password') && self.sign_in_count != 0
      self.password_alteration = 1
    end
  end

end
