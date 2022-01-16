# Base image:
FROM ruby:3.0.0

# Install dependencies and clean lists
RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential libpq-dev \
    nodejs && apt-get clean && rm -rf /var/lib/apt/list/*

# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV AABLD_ROOT /var/www/AABLD
RUN mkdir -p $AABLD_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $AABLD_ROOT

# Copy the main application.
COPY . .

# Install gems
RUN gem install bundler
RUN bundle install -j 20

EXPOSE 3000