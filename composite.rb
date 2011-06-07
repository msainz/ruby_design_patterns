
# Component pattern: the sum acts like one of the parts.
# It lets us build arbitrarily deep hierarchies (i.e. trees) of objects in which we can treat any
# interior node--a composite--just like any of the leaf nodes.

class Task

  attr_accessor :name, :parent

  def initialize name
    @name = name
    @parent = nil
  end
  
  def get_time_required
    0.0
  end
  
end

class CompositeTask < Task
  
  def initialize name
    super name
    @subtasks = []
  end
  
  def << task
    @subtasks << task
    task.parent = self
  end
  
  def [] index
    puts "f"
    @subtasks[index]
  end
  
  def get_time_required
    @subtasks.inject(0) { |total, task| total += task.get_time_required }
  end
  
end

class SomeSimpleTask < Task
  
  def initialize
    super 'Do something simple'
  end
  
  def get_time_required
    1.0
  end
  
end

class SomeComplexTask < CompositeTask

  def initialize
    super 'Do something complex'
    self << SomeSimpleTask.new
    self << SomeSimpleTask.new
  end
  
end

puts SomeComplexTask.new.get_time_required
