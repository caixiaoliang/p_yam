namespace :profile  do
  desc "create user profile for user"
  task :create_user_profile => :environment do
    User.find_each do |user|
      if user.is_verified?
        unless user.profile.present?
          user.create_profile
        end
      end
    end
  end
end