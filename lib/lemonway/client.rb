require "lemonway/core_ext/hash"
require 'savon'
require "rexml/document"

module Lemonway
  class Client

    class Error < StandardError; end

    attr_accessor :instance

    def initialize api_opts={}, client_opts={}, &block
      [api_opts, client_opts].each(&:symbolize_keys!)

      @xml_mini_backend = client_opts.delete(:xml_mini_backend)                        || ActiveSupport::XmlMini_REXML
      @entity_expansion_text_limit = client_opts.delete(:entity_expansion_text_limit)  || 10**20

      @instance = Savon.client client_opts.update(wsdl: api_opts.delete(:wsdl)), &block

      @api_options = api_opts.camelize_keys.with_indifferent_access
    end

    def operations
      @instance.operations
    end

    def method_missing method_name, *args, &block
      if operations.include? method_name.to_sym
        client_call method_name, *args, &block
      else
        super
      end
    end

    private

    def client_call method_name, message_opts = {}, client_opts = {}, &block
      resp = @instance.call method_name, client_opts.update(message: build_message(message_opts)), &block
      result  = resp.body.fetch(:"#{method_name}_response").fetch(:"#{method_name}_result")

      result = with_custom_parser_options { Hash.from_xml(result) } unless result.is_a? Hash
      result = result.underscore_keys(true).with_indifferent_access

      if result.key?(:e)
        raise Error, [result.fetch(:e).try(:fetch, :code), result.fetch(:e).try(:fetch, :msg)].join(' : ')
      elsif result.key?(:trans)
        result[:trans].fetch(:hpay, result[:trans])
      elsif result.key?(:wallet)
        result[:wallet]
      else
        result
      end

    rescue KeyError => e
      #todo improve this message
      raise Error, "#{e.message}, expected `#{method_name}_response.#{method_name}_result` but got : #{resp.body.inspect}"
    end

    # work around for
    # - Nokogiri::XML::SyntaxError: xmlns: URI Service_mb is not absolute
    # - RuntimeError: entity expansion has grown too large
    def with_custom_parser_options &block
      original_backend = ActiveSupport::XmlMini.backend
      original_text_limit = REXML::Document.entity_expansion_text_limit

      ActiveSupport::XmlMini.backend = @xml_mini_backend
      REXML::Document.entity_expansion_text_limit = @entity_expansion_text_limit

      yield

    ensure
      ActiveSupport::XmlMini.backend = original_backend
      REXML::Document.entity_expansion_text_limit = original_text_limit
    end

    def build_message opts = {}
      opts = @api_options.merge(opts.symbolize_keys.camelize_keys)
      [:amount, :amountTot, :amountCom].each do |key|
        opts[key] = sprintf("%.2f",opts[key]) if opts.key?(key) and opts[key].is_a?(Numeric)
      end
      [:updateDate].each do |key|
        opts[key] = opts[key].to_datetime.utc.to_i.to_s if opts.key?(key) and [Date, Time].any?{|k| opts[key].is_a?(k)}
      end
      opts
    end

  end

end

