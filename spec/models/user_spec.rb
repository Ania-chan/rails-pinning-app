require 'spec_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = User.create(first_name: "test", last_name: "test", email: "coder@skillcrush.com", password: "secret")
  end

  after(:all) do
    if !@user.destroyed?
      @user.destroy
    end
  end

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }


  it 'authenticates and returns a user when valid email and password passed in' do
    authenticated_user = User.authenticate(@user.email, @user.password)
    expect(authenticated_user).to eq(@user)
  end

end
