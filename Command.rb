require 'rally_api'
require 'csv'

require './Iteration_CRUD.rb'

# Default workspace is set to "Workspace 1" and project is set to "Rohan-test"
def start
  puts "Enter Workspace: 1. Workspace 1 \t2. USD"
  choice = gets.chomp

  case choice
  when "1" #Choose workspace 1
      
      @workspace = "Workspace 1"
      puts "Enter Project:"
      
      @project = gets.chomp
      puts "Enter your file name:#csv"
      
      file_name = gets.chomp
      puts "Enter command : 1. Create\t2. Update\t3. Read \t4. delete"
      command = gets.chomp
      
      @iCount = 0
      case command
      when "1" #create
        read_file(file_name)
        puts @rows
        
        puts "Workspace #{@workspace}"
        puts "Project #{@project}"
        puts "\n"
        
        puts "Do you want to create iteration for child projects? 1. Yes\t 2. No"
        request = gets.chomp
        iteration_crud = Iteration_CRUD.new(@workspace, @project)
        case request
        when "1"
        #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          result = iteration_crud.find_iteration(@rows[@iCount])
          if (result.length != 0)
            puts "Can't create , the same iteration exists!"
            puts "\n"
          else
           iteration_crud.create_iteration_for_child(@rows[@iCount])
          end

          @iCount += 1
        end
        
        when "2"
          #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          result = iteration_crud.find_iteration(@rows[@iCount])
          if (result.length != 0)
            puts "Can't create , the same iteration exists!"
            puts "\n"
          else
           iteration_crud.create_iteration(@rows[@iCount])
          end
          @iCount += 1
        end
        end
      when "2" #update
        read_file(file_name)
        puts @rows
        
        puts "Workspace #{@workspace}"
        puts "Project #{@project}"
        puts "\n"
        
        iteration_crud = Iteration_CRUD.new(@workspace, @project)
        
        #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          iteration_crud.update_iteration(@rows[@iCount])
          puts "\n"
          @iCount += 1
        end
        
      when "3" #read
        read_file(file_name)
        puts @rows
        
        puts "Workspace #{@workspace}"
        puts "Project #{@project}"
        puts "\n"
        
        iteration_crud = Iteration_CRUD.new(@workspace, @project)
        
        #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          iteration_crud.find_iteration(@rows[@iCount])
          @iCount += 1
          puts "\n"
        end
        
      when "4" #delete
        read_file(file_name)
        puts @rows
        
        puts "Workspace #{@workspace}"
        puts "Project #{@project}"
        puts "\n"
        
        puts "Do you want to delete iterations for child projects? 1. Yes\t 2. No"
        request2 = gets.chomp
        
        iteration_crud = Iteration_CRUD.new(@workspace, @project)
        
         # @iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
          while @iCount < @rows.length
            iteration_crud.delete_iteration(@rows[@iCount])
            @iCount += 1
          end
      end
          
    when "2" #choose USD
      @workspace = "USD"
      puts "Enter Project:"
      
      @project = gets.chomp
      puts "Enter your file name:#csv"
      
      file_name = gets.chomp
      puts "Enter command : 1. Create\t2. Update\t3. Read\t4. delete"
      command = gets.chomp
      @iCount = 0
      case command
      when "1" #create
        read_file(file_name)
        puts @rows
        
        puts "Workspace #{@workspace}"
        puts "Project #{@project}"
        puts "\n"
        
        puts "Do you want to create iteration for child projects? 1. Yes\t 2. No"
        request = gets.chomp
        iteration_crud = Iteration_CRUD.new(@workspace, @project)
        case request
        when "1" #create for all child projects
        #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          result = iteration_crud.find_iteration(@rows[@iCount])
          if (result.length != 0)
            puts "Can't create , the same iteration exists!"
            puts "\n"
          else
           iteration_crud.create_iteration_for_child(@rows[@iCount])
          end

          @iCount += 1
        end
        
        when "2" #create iteration only for listed projects
          #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          result = iteration_crud.find_iteration(@rows[@iCount])
          if (result.length != 0)
            puts "Can't create , the same iteration exists!"
            puts "\n"
          else
           iteration_crud.create_iteration(@rows[@iCount])
          end
          @iCount += 1
        end
        end
      when "2" #update
        read_file(file_name)
        puts @rows
        
        puts "Workspace #{@workspace}"
        puts "Project #{@project}"
        puts "\n"
        
        iteration_crud = Iteration_CRUD.new(@workspace, @project)
        
        #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          iteration_crud.update_iteration(@rows[@iCount])
          puts "\n"
          @iCount += 1
        end
        
      when "3" #read
        read_file(file_name)
        puts @rows
        
        puts "Workspace #{@workspace}"
        puts "Project #{@project}"
        puts "\n"
        
        iteration_crud = Iteration_CRUD.new(@workspace, @project)
        
        #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          iteration_crud.find_iteration(@rows[@iCount])
          @iCount += 1
          puts "\n"
        end
        
      when "4" #delete
        read_file(file_name)
        puts @rows
        
        puts "Workspace #{@workspace}"
        puts "Project #{@project}"
        puts "\n"
        
        iteration_crud = Iteration_CRUD.new(@workspace, @project)
        
        #@iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
        while @iCount < @rows.length
          iteration_crud.delete_iteration(@rows[@iCount])
          @iCount += 1
          puts "\n"
        end
      end
  end

end


def read_file(file_name)
  input = CSV.read(file_name)
  header = input.first
  #puts header
  @rows = []
  (1...input.size).each { |i| @rows << CSV::Row.new(header, input[i]) }
end

start