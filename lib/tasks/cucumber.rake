task :cucumber => :environment do
  unless system("bundle exec cucumber")
    raise 'Cucumber testing failed'
  end
end
