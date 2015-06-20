class Wiki < ActiveRecord::Base
  
  belongs_to :user

  scope :private_viewable, -> { where(private: true) }
  scope :public_viewable, -> { where(private: false) }
  
  default_scope { order('created_at DESC', 'updated_at DESC') }

  #default_scope { order('updated_at DESC') }

  #scope :visible_to, -> { select_viewable_wiki }

  end

  #def self.select_viewable_wiki
    # if (defined? User.current_user)
    #  if current_user.admin? or current_user.premium?
     # all
      #end
    #else
     # public_viewable
    #end
  #end

  #def set_private
   # wiki = Wiki.where(private: nil)
    #wiki.update_all(private: false)
  #end

