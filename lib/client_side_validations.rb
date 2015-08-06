module ClientSideValidations
  def self.included(base)
    base.instance_eval do |klass|
      @regexp = {}
      def validate_with_regexp(attr_name, params)
        validates_format_of attr_name, params.merge(:multiline => true)
        @regexp[attr_name] = params
      end

      def html_validation_attributes(attr_name)
        "data-psg-regexp='#{@regexp[attr_name][:with].source}' data-psg-input-optional='#{@regexp[attr_name][:allow_blank]==true}'" if @regexp[attr_name]
      end
    end
  end
end
