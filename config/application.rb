require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dms
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Route background jobs through Solid Queue (the default in Rails 8). The
    # async adapter runs jobs in-process, so enqueues from short-lived
    # processes (e.g. rake tasks) are lost when the process exits.
    config.active_job.queue_adapter = :solid_queue

    # Solid Queue's tables live in a separate `queue` database (see
    # config/database.yml). This connects SolidQueue::Record to that db so
    # job churn doesn't contend with the primary db.
    config.solid_queue.connects_to = { database: { writing: :queue } }

    # Mission Control::Jobs ships with HTTP Basic auth enabled by default; the
    # dashboard is mounted at /jobs. For a personal DMS accessed on a trusted
    # LAN (or behind a proxy that handles auth), we turn it off.
    config.mission_control.jobs.http_basic_auth_enabled = false

    # Root directory the DMS indexes. Points at an existing folder of files —
    # the app reads from it, never writes to it. Override with DMS_ROOT.
    config.dms_root = Pathname.new(ENV.fetch("DMS_ROOT", Rails.root.join("documents")))
  end
end
