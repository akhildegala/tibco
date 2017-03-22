# chef/handler/my_own_handler.rb
class MyOwnHandler < ::Chef::Handler

  def report
    puts 'Hello World'
  end
end
