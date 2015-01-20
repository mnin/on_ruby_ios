require 'yaml'

USER_GROUPS = %w(hamburg bremen cologne saar karlsruhe berlin leipzig dresden railsgirlshh bonn innsbruck madridrb)

config = YAML::load(File.read('.env'))

task default: [:download]

desc 'download latest jsons for all user groups'
task :download do
  USER_GROUPS.each do |user_group|
    puts "Download JSON for User Group: #{user_group}"
    url = "http://#{user_group}.onruby.de/api.json"
    system "curl -H 'x-api-key: #{config['api_key']}' #{url} | python -mjson.tool > onruby/data/#{user_group}.json"
  end
end
