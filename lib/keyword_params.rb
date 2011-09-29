require 'ostruct'
module KeywordParams
  class KeywordList
    def initialize
      @keywords = []
    end

    def add_keyword(name, default_block)
      @keywords << OpenStruct.new(name: name, default_block: default_block)
    end
    
    def values(options={})
      @keywords.map {|keyword|
        options.fetch(keyword.name, &keyword.default_block)
      }
    end
  end
  
  def keyword(name, &default_block)
    @keyword_list ||= KeywordList.new
    @keyword_list.add_keyword(name, default_block)
  end

  def method_added(name)
    # Avoid crazy stack recursion
    return if Thread.current[:in_keyword_params_method_added]
    Thread.current[:in_keyword_params_method_added] = true
    original_method = instance_method(name)
    keyword_list = @keyword_list
    @keyword_list = nil
    define_method(name) do |*args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      keyword_args = keyword_list.values(options)
      # We only need keyword arg values for as many positional args
      # as are NOT supplied.
      needed_keyword_args = keyword_args[(args.size..-1)]
      original_method.bind(self).call(*(args + needed_keyword_args))
    end
    super
    Thread.current[:in_keyword_params_method_added] = false
  end
end
