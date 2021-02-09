module ClientSideValidations
  def self.included(base)
    base.instance_eval do |klass|
      @regexp = {}
      def validate_with_regexp(attr_name, params)
        validates_format_of attr_name, params.merge(:multiline => true)
        @regexp[attr_name] = params
      end

      def html_validation_attributes(attr_name)
        return {} unless @regexp[attr_name]

        {
          :'data-psg-regexp' => "#{@regexp[attr_name][:with].source}",
          :'data-psg-input-optional' => "#{@regexp[attr_name][:allow_blank] == true}",
          :'data-psg-validation-error-msg' => "#{@regexp[attr_name][:error_msg]}"
        }.tap do |obj|
          # For the moment, it's just for data-psg-validation-error-msg
          obj.delete_if { |k, v| v.empty? }
        end
      end

      def validationErrorMsg(attr_name)
        nil if @regexp[attr_name].nil?
        @regexp[attr_name][:error_msg]
      end

      def html_input_control(attr_name, params)
        html_control("input", attr_name, params)
      end

      def html_control(html_tag, attr_name, params)
        %Q{
          <#{html_tag} #{params_obj_to_html_params(params.merge(html_validation_attributes(attr_name)))}>
        }
      end
    end
  end
end

def params_obj_to_html_params(params)
  params.to_a.map { |p| "#{p[0]}='#{p[1]}'" }.join(' ')
end
