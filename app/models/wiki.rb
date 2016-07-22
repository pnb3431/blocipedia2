class Wiki < ActiveRecord::Base
  belongs_to :user
  
  validates :title, presence: true
  validates :body, presence: true
  validates :user, presence: true

  scope :public_wikis, -> { where(private: false) }
  scope :visible_to, -> (user) { user ? all : public_wikis }
end
