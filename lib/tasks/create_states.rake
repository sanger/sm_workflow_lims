namespace :states do
  desc 'Create states'
  task create: [:environment] do
    puts 'Creating states...'
    StateFactory.states.each do |state|
      State.find_or_create_by(name: state[:name])
    end
  end
end
