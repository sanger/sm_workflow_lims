module ClientSideValidations
  def self.included(base)
    base.instance_eval do |klass|
      @regexp = {}
      def validate_with_regexp(attr_name, params)
        validates_format_of attr_name, params
        @regexp[attr_name] = params[:with]
      end

      def regexp_str(attr_name)
        @regexp[attr_name].source
      end
    end
  end
end
