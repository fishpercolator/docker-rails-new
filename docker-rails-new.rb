#!/usr/bin/env ruby

require 'date'
require 'erb'
require 'pathname'
require 'securerandom'

dir = Pathname.new(__FILE__).dirname

appname, *args = ARGV

# Sanity check some things
if Process.uid == 0
  abort 'Please add -u $(id -u) so files are not created as root'
end
unless %r{on /work} =~ %x{mount}
  abort 'Please mount /work using -v $(pwd):/work'
end
if !appname
  abort 'Please specify an app name'
end

system 'rails', 'new', '--database=postgresql', '--skip-bundle', appname, *args

# Now let's drop in our docker-compose.yml, Dockerfile, puma.rb and database.yml
{
  'docker-compose.yml' => '/',
  'Dockerfile'         => '/',
  'puma.rb'            => '/config',
  'database.yml'       => '/config'
}.each do |file, path|
  b = binding
  content = ERB.new(File.read "#{dir}/templates/#{file}.erb").result(b)
  File.write("#{appname}#{path}/#{file}", content)
end

# Make sure the gems we need are in the Gemfile
gemfile = File.read("#{appname}/Gemfile")
gemfile.sub!(/\n\n\n/, "\n\nruby '2.3.0'\n\n")
gemfile.sub!(/# Use Unicorn as the app server\n# gem 'unicorn'/, 
            "# Use Puma as the app server\ngem 'puma', '~> 2.16'")
gemfile.sub!(/# gem 'therubyracer'/, "gem 'therubyracer'")

gemfile += "group :production do\n  gem 'rails_12factor'\nend\n"

File.write("#{appname}/Gemfile", gemfile)

puts "Done! Now 'cd #{appname} && docker-compose build' to build your app"
puts "Afterwards you will probably want to:\n"
puts "  - add gems to the Gemfile and docker-compose run web bundle"
puts "  - docker-compose run web rake db:create"
