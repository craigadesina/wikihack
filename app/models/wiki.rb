class Wiki < ActiveRecord::Base
  
  has_many :collaborators, dependent: :destroy

  has_many :users, :through => :collaborators

  scope :private_viewable, -> { where(private: true) }
  scope :public_viewable, -> { where(private: false) }
  
  default_scope { order('created_at DESC', 'updated_at DESC') }

  validates :title, length: { within: 5..100 }
  validates :body, length: { within: 5..5000 }
  validates :owner, presence: true



  def owner
    User.find(user_id)
  end

  def public?
    private == false
  end

end

