# rails-new

A Docker container for bootstrapping a Docker Rails development environment

## Quickstart

    docker run -ti -u $(id -u) -v $(pwd):/work fishpercolator/rails-new $appname

Or, if you plan to use this a lot, make an alias:

    alias rails-new='docker run -ti -u $(id -u) -v $(pwd):/work fishpercolator/rails-new'
    rails-new $appname

After the environment has been bootstrapped:

    cd $appname
    docker-compose build
    vim Gemfile # add your favourite gems
    docker-compose run web bundle
    docker-compose run web rake db:create
    docker-compose up
    
And lo, your new application should be ready to go at <http://localhost:3000>.

## What this does

1. It runs 'rails new' with your app name and any arguments you provide.
2. It adds a Dockerfile and docker-compose.yml to the directory for building out the dev environment.
3. It configures the development and test databases to use the provided postgres container.
4. It adds puma, therubyracer and rails_12factor to the Gemfile and configures puma with a config/puma.rb

## Questions, comments

On Github: <https://github.com/fishpercolator/docker-rails-new>
