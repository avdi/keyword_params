# Note: this file is also the library test suite. Run `rake test` to
# verify the code is passing.

# Ruby doesn't have keyword arguments, but it fakes them pretty well.

def explain(options={})
  "the #{options[:the]} says #{options[:says]}"
end

explain the: "pig", says: "oink"    # => "the pig says oink"
explain the: "frog", says: "ribbit" # => "the frog says ribbit"

# Which is fine, but it isn't as declarative (and therefore not as
# self-documenting) as proper keyword arguments.

# Also, when using keywords to construct English-like DSLs, as we are
# above, we often would like to assign different names to the
# parameters which are passed by keyword.

def explain2(options={})
  animal = options[:the]
  sound  = options[:says]
  "the #{animal} says #{sound}"
end

# And then there's defaulting for missing paramters...

def explain3(options={})
  animal = options.fetch(:the) { "cow" }
  sound  = options.fetch(:says){ "moo" }
  "the #{animal} says #{sound}"
end

explain3 # => "the cow says moo"

# Of course, it might be nice to offer a positional-argument version
# as well.

def explain4(*args)
  options = args.last.is_a?(Hash) ? args.pop : {}
  animal  = args[0] || options.fetch(:the) { "cow" }
  sound   = args[1] || options.fetch(:says){ "moo" }
  "the #{animal} says #{sound}"
end

explain4 "horse", "neigh"        # => "the horse says neigh"
explain4 "duck", says: "quack"   # => "the duck says quack"
explain4 the: "donkey", :says => "hee-haw" # => "the donkey says hee-haw"

# Once we've written all this parameter-munging machinery, we then
# repeat it in the method's documentation. (Assuming we document it at
# all). This seems a bit un-DRY.

# Let's see if we can improve on the situation.

require 'keyword_params'

class BarnYard
  extend KeywordParams

  keyword(:the)  { "cow" }
  keyword(:says) { "moo" }
  def explain(animal, sound)
    "the #{animal} says #{sound}"
  end
end

b = BarnYard.new

b.explain "horse", "neigh"                  # => "the horse says neigh"
b.explain "duck", says: "quack"             # => "the duck says quack"
b.explain the: "donkey", :says => "hee-haw" # => "the donkey says hee-haw"
b.explain the: "cat"                        # => "the cat says moo"
b.explain                                   # => "the cow says moo"

# Improvement? Well, I'll leave that for you to judge. Certainly
# specifying part of the method's  signature above the method
# definition proper has a nasty "old-style C" feel to it. But I feel
# like it's a lot more self-documenting than doing the keyword
# processing inside the method.
