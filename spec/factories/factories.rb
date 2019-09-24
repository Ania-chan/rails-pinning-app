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
    board
  end

  factory :board do
    name "My Pins!"
    user
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

    factory :user_with_boards do
      after(:create) do |user|
        board = FactoryGirl.create(:board, user: user)
        create_list :pinning, 3, board: board, user: user
      end

      factory :user_with_boards_and_followers do
        after(:create) do |user|
          3.times do
            follower = FactoryGirl.create(:user)
            Follower.create(user_id: user, follower_id: follower.id)
          end
        end
      end
    end


    factory :user_with_followees do
      after(:create) do |user|
        3.times do        
          Follower.create(user: FactoryGirl.create(:user), follower_id: user.id)
        end
      end
    end
  end
end