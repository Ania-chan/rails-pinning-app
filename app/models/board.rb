class Board < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :user
  has_many :pinnings, inverse_of: :board, dependent: :delete_all
  has_many :pins, through: :pinnings
end
