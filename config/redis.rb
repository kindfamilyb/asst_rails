require 'redis'

# redis_url = Rails.application.credentials.dig(:REDIS_URL)

# Redis.current = Redis.new(url: redis_url)

# $redis = Redis.new(url: redis_url) { "redis://localhost:6379/1" })
redis = Redis.new(
  host: 'redis-service', # Redis 컨테이너 이름
  port: 6379             # Redis 기본 포트
)

# 연결 확인 로그
begin
    REDIS.ping # 성공 시 "PONG" 반환
    Rails.logger.info("Redis 연결 성공")
rescue => e
    Rails.logger.error("Redis 연결 실패: #{e.message}")
end