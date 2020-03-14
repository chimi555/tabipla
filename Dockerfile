FROM ruby:2.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    imagemagick \
    nodejs \
    fonts-ipafont \
    vim \
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir /app

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY . /app
RUN mkdir -p tmp/sockets

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]