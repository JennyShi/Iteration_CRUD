=begin
  
Author: Junyi Shi
Version: 1.0
Organization: EMC Corporation
Date Created: 10/16/2013.

Description: This is a simple script for create/update/delete interations from csv file.
  
=end

require 'rally_api' 
require 'date'

class Iteration_CRUD
  def initialize (workspace,project)
    headers = RallyAPI::CustomHttpHeader.new()
    headers.name = 'My Utility'
    headers.vendor = 'MyCompany'
    headers.version = '1.0'

    #==================== Making a connection to Rally ====================
    config = {:base_url => "https://rally1.rallydev.com/slm"}
    config = {:workspace => workspace}
    config[:project] = project
    config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()

    @rally = RallyAPI::RallyRestJson.new(config)
    #puts "Workspace #{@workspace}"
    #puts "Project #{@project}"
  end

#check http://developer.help.rallydev.com/ruby-toolkit-rally-rest-api-json 
#use the example on this page from "Querying Rally" 

  def find_project(project_name)
    query = RallyAPI::RallyQuery.new()
    query.type = :project
    query.fetch = "Name,Children"
    query.query_string = "(Name = \"#{project_name}\")"
    result = @rally.find(query)

    if(result.length != 0)
      puts "find the project #{project_name}"
    else 
      puts "project #{project_name} not found"
      #exit
    end
    result
  end

def find_iteration(row)
  query = RallyAPI::RallyQuery.new()
  query.type = :iteration   
  query.fetch = "Name,Project"
  query.project_scope_up = true
  query.project_scope_down = true
  query.order = "Name Asc"
  
  name = row["Name"]
  project = row["Project"]
  start_date = Date.strptime(row["Start Date"],'%m/%d/%Y').iso8601
  
  query.query_string = "(((Name = \"#{name}\")AND(Project.Name = \"#{project}\"))AND(StartDate = \"#{start_date}\"))"

  results = @rally.find(query)
  
  #query = RallyAPI::RallyQuery.new({:type => :Iteration ,:query_string => "(Name = \"Iteration #{iteration_name}\")"})
  #results = build_query("Iteration","Name","","((Name = \"#{iteration_name}\")AND(Project.Name = \"#{project_name}\"))") 
  if (results.length == 0)
    puts "#{row["Name"]} not found"
    #exit
  else
    results.each do |result|
      result.read
      puts "Iteration #{result.name} found"
      #puts DateTime.strptime(start_date,'%m/%d/%Y').iso8601
      puts "Name: #{result.Name}"
      puts "Project: #{result.Project}"
      puts "Start Date: #{result.StartDate}"
      puts "End Date: #{result.EndDate}"
    end
  end
  results
end

def update_iteration(row)
  puts "Managing row #{@iCount}"
  puts "Updating..."
  #result = find_project(row["Project"])
  if(find_project(row["Project"])!= nil)
    result = find_iteration(row)
    if(result.length != 0)
      @iteration = result.first
      puts @iteration["_ref"]
      field = {}
      
      if (row["New Name"] != nil)
        field["Name"] = row["New Name"]
        @rally.update("iteration","#{@iteration["_ref"]}",field)
        puts "#{row["Name"]} updated"

      end
  
      if (row["New Project"] != nil)
        res = find_project(row["New Project"])
        @res = res.first
        field["Project"] = @res["_ref"]
        @rally.update("iteration","#{@iteration["_ref"]}",field)
        puts "#{row["Name"]} updated"

      end
      
      if (row["New Start Date"] != nil)
        field["StartDate"] = Date.strptime(row["New Start Date"],'%m/%d/%Y').iso8601
        @rally.update("iteration","#{@iteration["_ref"]}",field)
        puts "#{row["Name"]} updated"

      end
      
      if (row["New End Date"] != nil)
        field["EndDate"] = Date.strptime(row["New End Date"],'%m/%d/%Y').iso8601
        @rally.update("iteration","#{@iteration["_ref"]}",field)
        puts "#{row["Name"]} updated"
 
      end
    end
  end
end

def delete_iteration(row)
  if(find_project(row["Project"]) != nil)
    result = find_iteration(row)
    if(result.length != 0)
      @iteration = result.first
      puts @iteration["_ref"]
      puts "Deleting..."
      @rally.delete(@iteration["_ref"])
      puts "#{row["Name"]} deleted"
    end
  else
    puts "Delete #{row["Name"]} failed!"
  end
end

def find_all_children(project_name)
    query = RallyAPI::RallyQuery.new()
    query.type = :project
    query.fetch = "Name,Children,State"
    query.query_string = "((Name = \"#{project_name}\")AND(State = \"Open\"))"
    result = @rally.find(query)
    
    result.each do |res|
      res.read
      #puts "Results :#{res}"
      if(res.Children.results == nil)
        @array.push(res)
      else
        @array.push(res)
        res.Children.results.each{|c|
          c.read
          if (c.State == "Open")
            find_all_children("#{c.Name}")            
          end
        }
       end
     end
          #@array.push(res)
=begin
      if(res.Children.results != nil)
        res.Children.results.each{|c|
          c.read
          if (c.State == "Open")
          #puts "Children: #{c.Children.results}"
          @array.push(c)
          #puts "Project : #{c.Name}"
          find_all_children("#{c.Name}")
          #@array.push(res)
          end
        }
      end
    end 
    #puts "Children projects : #{@array}"
=end
    puts "Projects : #{@array}"
    return @array

end

def create_iteration_for_child(row)
  #find_all_children(row["Project"])

  puts "Creating..."
  @array = []
  results = find_all_children(row["Project"])
  puts results

  results.each do |result|
#    result.read
#    puts "Project : #{result.Name}"
    
    res = find_project("#{result.Name}")
    @child = res.first
    field = {}
    field["Name"] = row["Name"]
    field["Project"] = @child["_ref"]
    field["StartDate"] = Date.strptime(row["Start Date"],'%m/%d/%Y').iso8601
    field["EndDate"] = Date.strptime(row["End Date"],'%m/%d/%Y').iso8601
    field["State"] = row["State"]
    @rally.create("iteration",field)
    puts "#{row["Name"]} created"
    puts "\n"
  end  

end
  
def create_iteration(row)
  puts "Creating..."
  results = find_project(row["Project"])
  @re = results.first
  field = {}
  field["Name"] = row["Name"]
  field["Project"] = @re["_ref"]
  field["StartDate"] = Date.strptime(row["Start Date"],'%m/%d/%Y').iso8601
  field["EndDate"] = Date.strptime(row["End Date"],'%m/%d/%Y').iso8601
  field["State"] = row["State"]
  create_iteration = @rally.create("iteration",field)
  puts "#{row["Name"]} created"
  puts "\n"
end

end