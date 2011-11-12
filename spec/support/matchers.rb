class HaveNamedScope  #:nodoc:
  def initialize(scope_name, options)
    @scope_name = scope_name.to_s
    @options    = options
  end

  def matches?(klass)
    @klass = klass
    @klass.send(@scope_name).proxy_options.should === @options
    true
  end

  def failure_message
    "expected #{@klass} to define named scope '#{@scope_name}' with options #{@options.inspect}, but it didn't"
  end

  def negative_failure_message
    "expected #{@klass} to not define named scope '#{@scope_name}' with options #{@options.inspect}, but it did"
  end
end

def have_named_scope(scope_name, options)
  HaveNamedScope.new(scope_name, options)
end
