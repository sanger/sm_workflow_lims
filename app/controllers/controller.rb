class Controller

  class NotImplimented < StandardError; end
  class ParameterError < StandardError; end

  class Validator
    def initialize(parameters,message)
      @parameters = parameters
      @message = message
    end

    def invalid!
      raise Controller::ParameterError, @message
    end
  end

  class RequiredValidator < Validator
    def validate(controller)
      return true if @parameters.all? {|parameter| controller.params.stringify_keys.key?(parameter.to_s)}
      invalid!
    end
  end

  class MethodValidator < Validator

    def validate(controller)
      return true if controller.send(@parameters)
      invalid!
    end
  end

  module ClassMethods

    def endpoint_validator(endpoint)
      @epv ||= Hash.new {|h,i| h[i] = Array.new }
      return @epv[endpoint]
    end

    def required_parameters_for(endpoint,parameters,message)
      endpoint_validator(endpoint) << RequiredValidator.new(parameters,message)
    end
    def validate_parameters_for(endpoint,method,message)
      endpoint_validator(endpoint) << MethodValidator.new(method,message)
    end

  end

  extend ClassMethods

  attr_reader :params

  def initialize(params=nil)
    @params = params||{}
  end


  def post
    valid_parameters_for!(:create)
    create
  end

  def get
    valid_parameters_for!(:show)
    show
  end

  def get_new
    valid_parameters_for!(:new)
    new
  end

  def get_index
    valid_parameters_for!(:new)
    index
  end

  def put
    valid_parameters_for!(:update)
    update
  end
  
  def delete
    valid_parameters_for!(:remove)
    remove
  end
  

  private

  def create
    raise NotImplimented
  end

  def show
    raise NotImplimented
  end

  def update
    raise NotImplimented
  end
  
  def remove
    raise NotImplimented
  end
  
  def new
    raise NotImplimented
  end

  def index
    raise NotImplimented
  end

  def valid_parameters_for!(endpoint)
    self.class.endpoint_validator(endpoint).all? {|validator| validator.validate(self) }
  end

  def user_error(message)
    raise Controller::ParameterError, message
  end

end
