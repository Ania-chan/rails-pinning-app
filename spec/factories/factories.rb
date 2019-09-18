FactoryGirl.define do

    factory :category do
      name "rails"
    end

    sequence :slug do |n| 
      "slug#{n}"
    end

    factory :pinning do
      pin
      user
    end

    factory :board do
      name "My Pins!"  
    end

    factory :pin do
      title "Rails Cheatsheet"
      url "http://rails-cheat.com"
      text "A great tool for beginning developers"
      slug
      category
    end

    factory :user do
      sequence(:email) { |n| "coder#{n}@skillcrush.com" }
      first_name "Skillcrush"
      last_name "Coder"
      password "secret"

      after(:create) do |user|
        user.boards << FactoryGirl.create(:board)
        create_list :pin, 3, pin: FactoryGirl.create(:pin), board: user.boards.first
    end
  end  

end
