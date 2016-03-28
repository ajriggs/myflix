class AppMailerInterceptor
 def self.delivering_email(message)
   admin_email = 'riggs.aaron@gmail.com'

   message.subject = "STAGING TEST #{message.subject}"
   message.to admin_email
 end
end
