
# We have a context which needs to perform an algorithm.
# We then have alternate versions of the algorithm in separate objects.

# 
# Strategy in its own class
#

class ImTheContext
  attr_reader :a, :b
  attr_accessor :strategy
  
  def initialize strategy
    @a = 'a'
    @b = [:b1, :b2]
    @strategy = strategy
  end
  
  def something
    @strategy.something self
  end
end

class StrategyA
  def something context
    puts "StrategyA.something: #{context.a.to_s}, #{context.b.to_s}"
  end
end

class StrategyB
  def something context
    puts "StrategyB.something: #{context.a.upcase.to_s}, #{context.b.join('|')}"
  end
end

context = ImTheContext.new(StrategyA.new)
context.something

context.strategy = StrategyB.new
context.something

#
# Strategy in a Proc a.k.a. "Quick-n-Dirty Strategy"
#

class ImAnotherContext
  attr_reader :a, :b
  attr_accessor :strategy
  
  def initialize &strategy
    @a = 'a'
    @b = [:b1, :b2]
    @strategy = strategy
  end
  
  def something
    @strategy.call self
  end
end

context = ImAnotherContext.new { |context| puts "I'm a quick-n-dirty strategy! #{context.a.to_s}" }
context.something

another_strategy = lambda { |context| puts "I'm another q-n-d strategy! #{context.b.to_s}" }
context.strategy = another_strategy
context.something

# Another example of strategy pattern:

a = ["aaa", "mm", "b"]
p a.sort
p a.sort {|x,y| x.length <=> y.length}

