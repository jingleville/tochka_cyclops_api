desc "Displays a list of available methods."

namespace :methods do
  task :list do
    puts TochkaCyclopsApi::Methods::METHODS
  end

  task :desc do
    puts TochkaCyclopsApi::Methods.get_method(ENV['method'])
  end
end