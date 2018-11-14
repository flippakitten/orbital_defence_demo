# frozen_string_literal: true

class SidekiqAuth
  def self.admin?(request)
    return true if Rails.env.development?
  end
end
