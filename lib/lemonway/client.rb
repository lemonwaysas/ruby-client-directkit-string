require "lemon_way/core_ext/hash"
require 'savon'
require "rexml/document"

module Lemonway
  class Client

    class Error < StandardError; end

    def initialize opts, &block
      @client = Savon.client(wsdl: opts.delete(:wsdl))

      Savon.client(&block) if block

      @xml_mini_backend = opts.delete(:xml_mini_backend)                        || ActiveSupport::XmlMini_REXML
      @entity_expansion_text_limit = opts.delete(:entity_expansion_text_limit)  || 10**20

      @options = opts.with_indifferent_access
    end

    def operations
      @client.operations
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
      resp = @client.call method_name, :message => @options.merge(args.extract_options!)
      xml  = resp.body.fetch(:"#{method_name}_response").fetch(:"#{method_name}_result")
      hash = with_custom_parser_options { Hash.from_xml(xml).underscore_keys(true).with_indifferent_access }

      val = if hash.key?(:e)
              raise Error, [response.fetch(:e).try(:fetch, :code), response.fetch(:e).try(:fetch, :msg)].join(' : ')
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



    # def make_body(method_name, attrs={})
    #   options = {}
    #   options[:builder] = Builder::XmlMarkup.new(:indent => 2)
    #   options[:builder].instruct!
    #   options[:builder].tag! "soap12:Envelope",
    #                          "xmlns:SOAP-ENV" => "http://schemas.xmlsoap.org/soap/envelope/",
    #                          "xmlns:ns1"=>"https://ws.hipay.com/soap/payment-v2" do
    #     options[:builder].tag! "SOAP-ENV:Body" do
    #       options[:builder].__send__(:method_missing, method_name.to_s.camelize, xmlns: "Service_mb") do
    #         @options.merge(attrs).each do |key, value|
    #           ActiveSupport::XmlMini.to_tag(key, value, options)
    #         end
    #       end
    #     end
    #   end
    # end
    #
    # def query(method, attrs={})
    #   http          = Net::HTTP.new(@uri.host, @uri.port)
    #   http.use_ssl  = true if @uri.port == 443
    #
    #   req           = Net::HTTP::Post.new(@uri.request_uri)
    #   req.body      = make_body(method, attrs)
    #   req.add_field 'Content-type', 'text/xml; charset=utf-8'
    #
    #   response = http.request(req).read_body
    #
    #   with_custom_parser_options do
    #     response = Hash.from_xml(response)["Envelope"]['Body']["#{method}Response"]["#{method}Result"]
    #     response = Hash.from_xml(response).with_indifferent_access.underscore_keys(true)
    #   end
    #
    #   if response.has_key?("e")
    #     raise Error, [response["e"]["code"], response["e"]["msg"]].join(' : ')
    #   elsif block_given?
    #     yield(response)
    #   else
    #     response
    #   end
    # end
    #
    # # quickly retreat date and big decimal potential attributes
    # def attrs_from_options attrs
    #   attrs.symbolize_keys!.camelize_keys!
    #   [:amount, :amountTot, :amountCom].each do |key|
    #     attrs[key] = sprintf("%.2f",attrs[key]) if attrs.key?(key) and attrs[key].is_a?(Numeric)
    #   end
    #   [:updateDate].each do |key|
    #     attrs[key] = attrs[key].to_datetime.utc.to_i.to_s if attrs.key?(key) and [Date, Time].any?{|k| attrs[key].is_a?(k)}
    #   end
    #   attrs
    # end


  end

end

