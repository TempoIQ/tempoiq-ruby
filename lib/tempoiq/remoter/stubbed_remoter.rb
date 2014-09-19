require 'digest/sha1'

require 'tempoiq/remoter/http_result'

module TempoIQ
  class StubbedRemoter
    def initialize
      @active_stubs = {}
    end

    def stub(http_verb, route, code, body = nil, headers = {})
      @active_stubs[key_for(http_verb, route)] = {
        :body => body,
        :code => code,
        :headers =>headers
      }
    end

    def get(route, body = nil, headers = {})
      return_stub(:get, route, body, headers)
    end

    def post(route, body = nil, headers = {})
      return_stub(:post, route, body, headers)
    end

    def delete(route, body = nil, headers = {})
      return_stub(:delete, route, body, headers)
    end

    def put(route, body = nil, headers = {})
      return_stub(:put, route, body, headers)
    end

    private

    def key_for(http_verb, route)
      Digest::SHA1.hexdigest(http_verb.to_s+route)
    end

    def return_stub(http_verb, route, body, headers)
      stub = @active_stubs[key_for(http_verb, route)]
      if stub.nil?
        raise "Real HTTP Connections are not allowed. #{http_verb} #{route} didn't match any active stubs"
      else
        HttpResult.new(stub[:code], stub[:headers], stub[:body])
      end
    end
  end
end
