require "faceless/configuration"
require "faceless/authcode"

module Faceless
  class << self

    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def authenticator
      Faceless::Authcode
    end

    private

    def method_missing method, *args, &block
      return super unless authenticator.respond_to?(method)
      authenticator.send(method, *args, &block)
    end
  end
end