namespace :crt do
  desc "Add the default superadmin"
  task :default_superadmin => :environment do
    user = User.new(:email => 'superadmin@example.com', :first_name => 'Super', :last_name => 'Admin')
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
  
  desc "Add the test accounts"
  task :default_libadmin => :environment do
    if %w[development dev local].include?(Rails.env)
      user = User.new(:email => 'libadmin@example.com', :first_name => 'Library', :last_name => 'Admin')
      user.password = "12345678"
    end
    user.admin = true
    user.save
    puts "Lib Admin email is: #{user.email}"
    puts "Lib Admin password is: #{user.password}"
  end
  task :default_libstaff => :environment do
    if %w[development dev local].include?(Rails.env)
      user = User.new(:email => 'libstaff@example.com', :first_name => 'Library', :last_name => 'Staff')
      user.password = "12345678"
    end
    user.admin = true
    user.save
    puts "Lib Staff email is: #{user.email}"
    puts "Lib Staff password is: #{user.password}"
  end
  task :default_pubadmin => :environment do
    if %w[development dev local].include?(Rails.env)
      user = User.new(:email => 'pubadmin@example.com', :first_name => 'Publisher', :last_name => 'Admin')
      user.password = "12345678"
    end
    user.admin = true
    user.save
    puts "Pub Admin email is: #{user.email}"
    puts "Pub Admin password is: #{user.password}"
  end
  task :default_pubstaff => :environment do
    if %w[development dev local].include?(Rails.env)
      user = User.new(:email => 'pubstaff@example.com', :first_name => 'Publisher', :last_name => 'Staff')
      user.password = "12345678"
    end
    user.admin = true
    user.save
    puts "Pub Staff email is: #{user.email}"
    puts "Pub Staff password is: #{user.password}"
  end
  
  desc "Add the default libraries"
  task :default_libraries => :environment do
    ['Widener', 'Houghton', 'Fine Arts'].each do |library|
      library = Library.new(:name => library, :contact_name => "Default Contact", :phone => "XXX-XXX-XXXX", :email => "contact@example.com", :address_1 => "1 Smart Lane", :city => "Boston", :state => "MA", :postal_code => "02111", :country => "US")
      library.save
    end
    puts "Libraries Added!"
  end
  
  desc "Add the default publishers"
  task :default_publishers => :environment do
    ['Rosoff', 'Tupelo', 'Harvard', 'MIT'].each do |publisher|
      publisher = Publisher.new(:name => publisher, :contact_name => "Default Contact", :phone => "XXX-XXX-XXXX", :email => "contact@example.com", :address_1 => "1 Smart Lane", :city => "Boston", :state => "MA", :postal_code => "02111", :country => "US")
      publisher.save
    end
    puts "Publishers Added!"
  end
  
  desc "run all tasks in bootstrap"
  task :run_all => [:default_superadmin, :default_libadmin, :default_libstaff, :default_pubadmin, :default_pubstaff, :default_libraries, :default_publishers] do
    puts "Created Admin account, Repos, Locations and Rooms!"
  end
end    