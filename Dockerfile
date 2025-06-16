FROM ruby:3.1.2

WORKDIR /app

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.4.22 && \
    bundle _2.4.22_ install

# Copy application code
COPY . .

# Expose ports
EXPOSE 9292

# Start the application with proper logging
ENV RACK_ENV=development
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "--host", "0.0.0.0"] 