module DataSift
  class ApiResource
    include DataSift

    def initialize (config)
      @config = config
      config[:api_host] = 'api.datasift.com' unless config.has_key?(:api_host)
      config[:stream_host] = 'websocket.datasift.com' unless config.has_key?(:stream_host)
      config[:api_version] = 'v1' unless config.has_key?(:api_version)
      config[:enable_ssl] = true unless config.has_key?(:enable_ssl)
      # Only SSLv3, TLSv1 and TLSv1.2 currently supported, TLSv1.2 preferred
      #   this is fixed in REST client and is scheduled for the 1.7.0 release
      #   see https://github.com/rest-client/rest-client/pull/123

      ssl_default = "TLSv1_2"
      if RUBY_VERSION.to_i == 1
        ssl_default = "TLSv1"
      end
      OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = config[:ssl_version] ||
        ssl_default

      # max 320 seconds retry - http://dev.datasift.com/docs/streaming-api/reconnecting
      config[:max_retry_time] = 320 unless config.has_key?(:max_retry_time)
      config[:retry_timeout] = 0 unless config.has_key?(:retry_timeout)
    end

    def requires params
      params.each { |k, v|
        if v == nil || v.to_s.length == 0
          raise InvalidParamError.new "#{k} is a required parameter, it cannot be nil or empty"
        end
      }
    end
  end
end
