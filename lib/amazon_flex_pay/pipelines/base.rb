module AmazonFlexPay::Pipelines #:nodoc:
  class Base < AmazonFlexPay::Model #:nodoc:
    attribute :'returnURL' # required
    attribute :caller_reference # required
    attribute :cobranding_style
    attribute :cobranding_url
    attribute :website_description

    # Converts the Pipeline object into parameters and signs them.
    def to_param(client)
      params = to_hash.merge(
        'callerKey' => client.access_key,
        'signatureVersion' => 2,
        'signatureMethod' => 'HmacSHA256'
      )
      params['signature'] = client.sign(client.cbui_endpoint, params)
      AmazonFlexPay::Util.query_string(params)
    end

    def to_hash
      super().merge(
        'pipelineName' => pipeline_name,
        'version' => AmazonFlexPay::PIPELINE_VERSION
      )
    end

    protected

    # For pipelines, parameter keys are camelCase instead of CamelCase.
    def format_key(key)
      key.camelcase(:lower)
    end

    def pipeline_name #:nodoc:
      self.class.to_s.split('::').last
    end
  end
end
