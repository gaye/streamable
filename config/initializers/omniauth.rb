Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '206560469458633', 'e3db3b9feee77af9da2d4cd3932d83e2', :display => 'popup'
end
