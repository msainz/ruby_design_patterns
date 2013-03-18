
#
# Clean interface between a source of news (the subject or observable) and the consumer
# of the news (the observers). 
# 

#
# Example 1
#

module Subject
  def initialize
    @observers = []
  end
  
  # consider using reflection so adding observers explicitly not necessary i.e. EmployeeObserver
  def add_observer observer
    @observers << observer
  end
  
  def delete_observer observer
    @observers.delete observer
  end
  
  def notify_observers
    @observers.each {|o| o.update self}
  end
end

class Employee
  include Subject
  attr_reader :name
  attr_accessor :salary
  
  def initialize name, salary
    super() # you need the parens here, otherwise args will be passed up
    @name = name
    @salary = salary
  end
  
  def salary= new_salary
    @salary = new_salary
    notify_observers
  end
end

class Payroll
  def update subject # consider taking more arguments to capture old state
    puts "Cut a new check for #{subject.name} for #{subject.salary}"
  end
end

e = Employee.new 'Fred', 70000
e.add_observer Payroll.new
e.salary += 10000

#
# Example 2: code blocks as observers
#

module Subject
  attr_reader :observers
  def initialize
    @observers = []
  end
  
  # consider using reflection so adding observers explicitly not necessary i.e. EmployeeObserver
  def add_observer &observer
    @observers << observer
  end
  
  def notify_observers
    @observers.each {|o| o.call self}
  end
end  
  
e = Employee.new 'Mary', 90000
e.add_observer {|subject| puts "#{subject.name}'s salary has changed to #{subject.salary}"}
p e.observers
e.salary += 15000
  
#
# Example 3: using built-in "Observable" module
#  

require 'observer'
class GolfPlayer
  include Observable
  attr_reader :name
  attr_accessor :handicap
  
  def initialize name, handicap
    @name = name
    @handicap = handicap
  end
  
  def handicap= new_handicap
    if @handicap != new_handicap
      old_handicap = @handicap
      @handicap = new_handicap
      changed
      notify_observers self, old_handicap
    end
  end
end

class GolfPlayerObserver
  def update subject, old_handicap
    puts "#{subject.name} has changed handicap from #{old_handicap} to #{subject.handicap}"
  end
end

gp = GolfPlayer.new 'Tiger', 2
gp.add_observer GolfPlayerObserver.new
gp.handicap -= 3

#
# Example 4: observers of database records
#  

require 'rubygems'
require 'fileutils'
require 'active_record'
require 'logger'
require 'ap'

# start from scratch
`rm database.db`

# http://blog.joyofthink.com/yangchen/blog1.php/2010/06/14/activerecord-without-rails
ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'database.db')

ActiveRecord::Schema.define do
  create_table :players do |table|
    table.string :name
  end
end

ActiveRecord::Base.logger = Logger.new(STDERR)

class Player < ActiveRecord::Base
  after_create do
    logger.info('player created!')
  end
  after_update do
    logger.info('player updated!')
  end
  after_destroy do
    logger.warn('player destroyed!')
  end
end

class PlayerObserver < ActiveRecord::Observer
  def after_create player # called just after Player#save
    player.logger.info 'External observer: player created!'
  end
  def after_update player
    player.logger.info 'External observer: player updated!'
  end
  def after_destroy player
    player.logger.warn 'External observer: player destroyed!'
  end
end

# Observers are singletons and this call instantiates and registers them.
Player.observers << PlayerObserver.instance

Player.new(:name => 'Winston').save
p = Player.first
p.name = 'Gabby'
p.save
p.destroy
