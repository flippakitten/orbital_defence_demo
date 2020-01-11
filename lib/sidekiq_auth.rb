# frozen_string_literal: true

class SidekiqAuth
  def self.admin?(request)
    return true if Rails.env.development?
    return true if ENV['SIDEKIQ_ADMIN_ON'].to_s == true
  end
end
