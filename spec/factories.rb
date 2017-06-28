FactoryGirl.define do

  factory :user do
    username { Faker::Internet.user_name }
    password { Faker::Internet.password(8,100) }
    roles    TWG4::CONFIG[:new_user_roles_default]
    display_name { username.gsub(/[_\.-]/, ' ').capitalize }

    trait(:moderator)   { roles TWG4::CONFIG[:new_user_roles_default] + ['moderator'] }
    trait(:admin)       { roles TWG4::CONFIG[:new_user_roles_default] + ['admin'] }
    trait(:super_admin) { roles TWG4::CONFIG[:new_user_roles_default] + ['super_admin'] }
  end

  factory :album do
    name { Faker::Book.title }
    association :owner, factory: :user

    trait :with_photos do
      transient { photos_count 7 }

      after(:create) do |album, evaluator|
        (1..evaluator.photos_count).each do |i|
          photo = create(:photo, owner: album.owner)
          create(:photo_in_album, album: album, photo: photo, display_order: i)
        end
      end
    end
  end

  factory :photo do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'uploads', 'photo_images', 'sample_photo_image.jpg'), 'image/jpg') }
    description { Faker::Lorem.paragraph(1, false, 2) }

    trait :in_album do
      association :owner, factory: :user

      after(:create) do |photo|
        album = create(:album, owner: photo.owner)
        create(:photo_in_album, album: album, photo: photo)
      end
    end

    trait :with_comments do
      transient { comments_count 5 }

      after(:create) do |photo, evaluator|
        create_list(:comment, evaluator.comments_count, photo: photo)
      end
    end
  end

  factory :photo_in_album do
    association :album
    association :photo
    display_order 1
  end

  factory :comment do
    content { Faker::Lorem.paragraph }
    association :author, factory: :user
    association :photo
  end

end