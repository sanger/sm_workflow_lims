namespace :build do
  task :assets => ['assets:precompile'] do
    `cp -r $(bundle show bootstrap-sass)/vendor/assets/fonts/bootstrap public/assets/stylesheets/`
  end
end
