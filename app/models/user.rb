class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email
  has_many :pinnings, dependent: :delete_all
  has_many :pins, through: :pinnings
  has_many :boards, inverse_of: :user, dependent: :delete_all

  def self.authenticate(email, password)
    @user = User.find_by_email(email)

    if !@user.nil?
      if @user.authenticate(password)
        return @user
      end
    end

    return nil
  end

end

