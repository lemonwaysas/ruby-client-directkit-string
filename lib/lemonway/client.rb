require "lemonway/core_ext/hash"
require 'savon'
require "rexml/document"

module Lemonway
  class Client

    class Error < StandardError; end

    attr_accessor :instance

    def initialize opts, &block
      @instance = Savon.client(wsdl: opts.symbolize_keys!.delete(:wsdl))

      Savon.client(&block) if block

      @xml_mini_backend = opts.delete(:xml_mini_backend)                        || ActiveSupport::XmlMini_REXML
      @entity_expansion_text_limit = opts.delete(:entity_expansion_text_limit)  || 10**20

      @options = opts.camelize_keys.with_indifferent_access
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

    def client_call method_name, *args, &block
      resp = @instance.call method_name, :message => build_message(args.extract_options!)
      xml  = resp.body.fetch(:"#{method_name}_response").fetch(:"#{method_name}_result")
      hash = with_custom_parser_options { Hash.from_xml(xml).underscore_keys(true).with_indifferent_access }

      val = if hash.key?(:e)
              raise Error, [hash.fetch(:e).try(:fetch, :code), hash.fetch(:e).try(:fetch, :msg)].join(' : ')
            elsif hash.key?(:trans)
              hash[:trans][:hpay]
            elsif hash.key :wallet
              hash[:wallet]
            else
              hash
            end

      if block_given?
        yield(val)
      else
        val
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
      opts = @options.merge(opts.symbolize_keys.camelize_keys)
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

