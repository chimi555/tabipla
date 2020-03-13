FROM ruby:2.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    imagemagick \
    nodejs \
    fonts-ipafont \
    vim \
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir /triplog

WORKDIR /triplog

COPY Gemfile /triplog/Gemfile
COPY Gemfile.lock /triplog/Gemfile.lock

RUN bundle install

COPY . /triplog
RUN mkdir -p tmp/sockets

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "rails", "s", "puma", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]