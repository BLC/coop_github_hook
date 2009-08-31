desc "Copies all the contents of this over to a specified server"
task :deploy do
  require 'yaml'

  deploy_options = YAML.load(File.read('config/deploy.yml'))
  deploy_to = "#{deploy_options['server']}:#{deploy_options['folder']}"
  puts "Deploying to #{deploy_to}"
  system("scp -r * #{deploy_to}")
end