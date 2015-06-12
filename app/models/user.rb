class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_initialize :set_role, if: :new_record?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  has_many :wikis, dependent: :destroy

  has_many :transactions, dependent: :destroy

  enum role: [:standard, :premium, :admin]

  

  def set_role
    self.role ||= :standard
  end
end
