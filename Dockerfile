FROM ruby:2.4
RUN gem install rails

RUN mkdir /usr/src/app /work
ADD docker-rails-new.rb /usr/src/app/
ADD templates /usr/src/app/templates
RUN chmod +x /usr/src/app/docker-rails-new.rb 
WORKDIR /work

ENTRYPOINT ["/usr/src/app/docker-rails-new.rb"]
