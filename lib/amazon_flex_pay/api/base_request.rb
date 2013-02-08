module AmazonFlexPay::API #:nodoc:
  class BaseRequest < AmazonFlexPay::Model #:nodoc:
    def to_param(client)
      params = to_hash.merge(
        'AWSAccessKeyId' => client.access_key,
        'Timestamp' => format_value(Time.now),
        'SignatureVersion' => 2,
        'SignatureMethod' => 'HmacSHA256'
      )
      params['Signature'] = client.sign(client.api_endpoint, params)
      AmazonFlexPay::Util.query_string(params)
    end

    # Converts the API request object into parameters and signs them.
    def to_hash
      super.merge(
        'Action' => action_name,
        'Version' => AmazonFlexPay::API_VERSION
      )
    end

    def action_name #:nodoc:
      self.class.to_s.split('::').last
    end

    class BaseResponse < AmazonFlexPay::Model #:nodoc:
      attribute :request
      attribute :request_id

      # Parses Amazon's XML response to REST requests and instantiates the response.
      def self.from_xml(xml)
        response = MultiXml.parse(xml)

        response_key = response.keys.find{|k| k.match(/Response$/)}
        hash = response[response_key]['ResponseMetadata']

        result_key = response[response_key].keys.find{|k| k.match(/Result$/)}
        hash.merge!(response[response_key][result_key]) if response[response_key][result_key] # not all APIs have a result object

        new(hash)
      end
    end

    class ErrorResponse < AmazonFlexPay::Model #:nodoc:
      attribute :request_id

      def self.from_xml(xml)
        new(MultiXml.parse(xml)['Response'])
      end

      attr_reader :errors
      def errors=(val)
        @errors = [val['Error']].flatten.map{|e| Error.new(e)}
      end

      class Error < AmazonFlexPay::Model #:nodoc:
        attribute :code
        attribute :message
      end
    end
  end
end
