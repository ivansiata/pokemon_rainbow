require 'csv'
namespace :pokemon_rainbow do
  desc "Drop and Seed"
  task drop_and_seed: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute

  end

end
