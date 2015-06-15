class Wiki < ActiveRecord::Base
  belongs_to :user

  scope :private_viewable, -> { where(private: true) }
  scope :public_viewable, -> { where(private: false) }

end
