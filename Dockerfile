# syntax=docker/dockerfile:1

ARG RUBY_VERSION=4.0.2
FROM ruby:${RUBY_VERSION}-slim

# System packages.
#   build-essential, git          : compile native gem extensions
#   libsqlite3-dev, sqlite3       : database
#   poppler-utils                 : pdftoppm for PDF thumbnails
#   libvips                       : fast raster image resizing
#   tesseract-ocr, tesseract-ocr-eng : OCR (used later by IndexDocumentJob)
#   tzdata                        : time zone data; Rails assumes this exists
#   curl                          : healthcheck-friendly
#
# Uncomment libreoffice to enable .docx / .xlsx thumbnailing (~500 MB).
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      curl \
      tzdata \
      sqlite3 \
      libsqlite3-dev \
      libyaml-dev \
      poppler-utils \
      libvips \
      tesseract-ocr \
      tesseract-ocr-eng \
      # libreoffice \
    && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    RAILS_SERVE_STATIC_FILES=1 \
    RAILS_LOG_TO_STDOUT=1

WORKDIR /app

# Install gems first — keeps this layer cached when only app code changes.
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 && \
    rm -rf "$BUNDLE_PATH"/ruby/*/cache

# Copy the rest of the app
COPY . .

# Precompile assets. SECRET_KEY_BASE_DUMMY tells Rails 8 to use a throwaway
# key for the build only — the real key is supplied at runtime.
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails tailwindcss:build && \
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# The directory indexed by the scanner is expected to be mounted at /data.
ENV DMS_ROOT=/data

# SQLite database and thumbnails live here — mount as a volume in production.
VOLUME ["/app/storage"]

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
