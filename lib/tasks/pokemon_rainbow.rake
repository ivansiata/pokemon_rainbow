namespace :pokemon_rainbow do
  desc "TODO"
  task drop_and_seed: :environment do
    pokedex_csv = CSV.open('list_pokedex.csv', :headers => true, header_converters: :symbol)
  end

end
