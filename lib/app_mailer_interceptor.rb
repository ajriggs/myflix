class AppMailerInterceptor
 def self.delivering_email(message)
   ADMIN_EMAIL = 'riggs.aaron@gmail.com'

   message.subject = "STAGING TEST #{message.subject}"
   message.to = ADMIN_EMAIL
 end
end
