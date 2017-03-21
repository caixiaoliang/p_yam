Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, "wx48b3894746ee015b","fc26999d92ec2a7acd20ca973664774a",:authorize_params => {:redirect_uri => "http://www.example.com/sessions/auth_callback"}
end
# You can now access the OmniAuth Wechat OAuth2 URL: /auth/wechat

# You can now access the OmniAuth Wechat OAuth2 URL: /auth/wechat
  # provider :wechat, ENV["wxcd1ca2837f9b082b"],ENV["27543e0a4a934ba7495fa17fde552450"] 
  # provider :wechat, ENV["WECHAT_APP_ID"],ENV["WECHAT_APP_SECRET"] 


