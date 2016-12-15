Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  #config.action_mailer.raise_delivery_errors = false

  #config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.web_console.whitelisted_ips = '192.168.0.0/16'


  config.middleware.use HtmlCompressor::Rack,
                        compress_css: true,
                        compress_javascript: true,
                        css_compressor: :yui,
                        javascript_compressor: :yui,
                        enabled: true,
                        preserve_line_breaks: false,
                        remove_comments: true,
                        remove_form_attributes: false,
                        remove_http_protocol: false,
                        remove_https_protocol: false,
                        remove_input_attributes: false,
                        remove_intertag_spaces: false,
                        remove_javascript_protocol: true,
                        remove_link_attributes: true,
                        remove_multi_spaces: true,
                        remove_quotes: true,
                        remove_script_attributes: true,
                        remove_style_attributes: true,
                        simple_boolean_attributes: true,
                        simple_doctype: false
end
