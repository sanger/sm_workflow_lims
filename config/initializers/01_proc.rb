# www.mattsears.com/articles/2011/11/27ruby-blocks-as-dynamic-callbacks
class Proc
  def callback(callable, *)
    self === Class.new do
      method_name = callable.to_sym
      define_method(method_name) { |&block| block ? block.call(*) : true }
      define_method(:"#{method_name}?") { true }
      def method_missing(*_args)
        false
      end
    end.new
  end
end
