class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_initialize :set_role, if: :new_record?

  extend FriendlyId

  friendly_id :name, :use => :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  
  has_many :wikis, :through => :collaborators

  has_many :transactions, dependent: :destroy

  has_many :collaborators, dependent: :destroy

  enum role: [:standard, :premium, :admin]

  validates :name, presence: true

  def set_role
    self.role ||= :standard
  end

  def make_wikis_public
    wikis.any? do |wiki|
      wiki.private? and (wiki.owner == self.id)
      wiki.update(:private => false)
    end
  end

end
