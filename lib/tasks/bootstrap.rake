namespace :crt do
  desc "Add the default superadmin"
  task :default_admin => :environment do
    user = User.new(:email => 'admin@example.com')
    if %w[development test dev local].include?(Rails.env)
      user.password = "12345678"
    else
      user.password = User.random_password
    end
    user.superadmin = true
    user.save
    puts "Super Admin email is: #{user.email}"
    puts "Super Admin password is: #{user.password}"
  end
end    