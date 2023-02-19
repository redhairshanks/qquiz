$redis = Redis.new({
                     host:  Rails.configuration.x.app_config.redis[:host],
                     port: Rails.configuration.x.app_config.redis[:port],
                     db: 0,
                     password: nil
                   })