class JsonWebToken
  SECRET_KEY = ENV['SECRET_KEY_BASE'] || Rails.application.credentials.secret_key_base.to_s

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    return nil if BlacklistedToken.exists?(token: token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')[0]
    decoded
  rescue JWT::DecodeError
    nil
  end
end
