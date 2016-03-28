ActionMailer::Base.register_interceptor(AppEmailInterceptor) if Rails.env.staging?
