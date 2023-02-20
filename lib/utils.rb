class Utils

  def self.cache(k,v, expiry = 90.minutes)
    Rails.cache.write(k,v, expires_in: expiry)
  end

  def self.cache_read(k)
    v = Rails.cache.exist?(k) ? Rails.cache.read(k) : nil
    v.present? && v.instance_of?(Hash) ? v.symbolize_keys : v
  end

  def self.cache_set(set_name, k , v, expiry = 90.minutes)
    $redis.hset(set_name, k,v)
    $redis.expire(set_name, expiry.to_i) unless $redis.ttl(set_name) > 0
  end

  def self.cache_set_read(set_name, k)
    $redis.hget(set_name, k)
  end

  def self.cache_del(k)
    Rails.cache.delete(k)
  end

  class StringUtility
    def self.is_date?(dt)
      begin
        Date.parse(dt)
        true
      rescue ArgumentError
        false
      end
    end

    def self.is_email?(str)
      str.to_s.match(URI::MailTo::EMAIL_REGEXP).present?
    end
  end

end