# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:3000',
              'http://49.171.12.248',
              'http://www.asst.kr', 
              'http://www.asst.kr:80', 
              'http://www.asst.kr:3000', 
              'http://www.asst.kr:3333',
              'http://nextjsapp:3000'
  
      # 허용할 리소스 및 HTTP 메서드를 지정합니다.
      resource '*',
        credentials: true,
        headers: :any,
        methods: %i(get post put patch delete options head),
        expose: %w(Content-Type X-Requested-With)
    end
  end