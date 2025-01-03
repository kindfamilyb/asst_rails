require 'redis'

class RedisService
  def self.instance
    @redis ||= Redis.new(
      host: 'redis-service', # Redis 컨테이너 이름
      port: 6379
    )
  end

  def self.set(key, value)
    instance.set(key, value)
  end

  def self.get(key)
    instance.get(key)
  end
end