
class Base
  def initialize a, b
    @a, @b = a, b
  end
  
  def something
    something_first
    template_method
    something_last
  end
  
  def something_first
    puts 'first'
  end
  
  def something_last
    puts 'last'
  end
end

class SubclassOne < Base
  def template_method
    puts "SubclassOne: #{@a.to_s}, #{@b.to_s}"
  end
end

class SubclassTwo < Base
  def template_method
    puts "SubclassTwo: #{@a.to_s}, #{@b.to_s}"
  end
end

SubclassOne.new(:a, :b).something
SubclassTwo.new(:a, :b).something