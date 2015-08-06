if ENV['RESQUE_ENABLED']
  Resque.redis = Redis.new(url:ENV['REDIS_HOST'])
end