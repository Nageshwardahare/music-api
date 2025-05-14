Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # replace with React domain in prod
    resource '*', headers: :any, methods: [:get]
  end
end
