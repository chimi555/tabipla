FROM ruby:2.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    imagemagick \
    nodejs \
    fonts-ipafont \
    vim \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir /myapp

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]