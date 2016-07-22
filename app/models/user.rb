class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  after_initialize :give_standard_role
  
  
  has_many :wikis

  
  validates :role, presence: true
  

  enum role: [:standard, :premium, :admin]

  private
  def give_standard_role
    self.role ||= :standard
  end

end
