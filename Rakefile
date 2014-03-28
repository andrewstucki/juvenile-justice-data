namespace :build do
  task :java do
  	require "ant"
  	args = ["-f", "build.xml"]
  	Dir.chdir "java" do
      ant args
    end
  end
end

namespace :data do
  require "lib/ruby/data_utils"
  require "lib/ruby/states"
  require "lib/ruby/cities"
  
  namespace :csv do
    task :generate, :year do |t, args|
      args.with_defaults(:year => "all")
      if args[:year] == "all"
          DataUtils.valid_years.each do |year|
            DataUtils.offense_dump("data/raw/offenses/#{year}.dta", "data/offenses/#{year}")
          end
      else
        DataUtils.offense_dump("data/raw/offenses/#{args[:year]}.dta", "data/offenses/#{args[:year]}")
      end
    end
    
    task :statistics, :state do |t, args|
      args.with_defaults(:state => "valid")
      if args[:state] == "valid"
        States.reporting_states.each_key do |state|
          DataUtils.generate_plot_files(state, "data/rates/#{state}")
        end
        DataUtils.generate_plot_files("Total", "data/rates/Total")
      elsif args[:state] == "all"
        States.all.each do |state|
          DataUtils.generate_plot_files(state, "data/rates/#{state}")
        end
      else
        DataUtils.generate_plot_files(args[:state], "data/rates/#{args[:state]}")
      end
    end
    
    namespace :city do
      task :generate, :year do |t, args|
        args.with_defaults(:year => "all")
        if args[:year] == "all"
            DataUtils.valid_years.each do |year|
              DataUtils.city_offense_dump("data/raw/offenses/#{year}.dta", "data/offenses/#{year}/cities")
            end
        else
          DataUtils.city_offense_dump("data/raw/offenses/#{args[:year]}.dta", "data/offenses/#{args[:year]}/cities")
        end
      end
    
      task :statistics, :city do |t, args|
        args.with_defaults(:city => "valid")
        if args[:city] == "valid"
          Cities.reporting_cities.each_key do |city|
            DataUtils.generate_city_plot_files(city, "data/rates/cities/#{city}")
          end
        else
          DataUtils.generate_city_plot_files(args[:city], "data/rates/cities/#{args[:city]}")
        end
      end
      
      task :populations, :city do |t, args|
        require 'pp'
        args.with_defaults(:city => "valid")
        if args[:city] == "valid"
          Cities.reporting_cities.each do |state, city|
            DataUtils.valid_years.each do |year|
              pp DataUtils.get_city_population(city, state, year)
            end
          end
        else
        end
      end
      
      task :rates do
        DataUtils.csv_rates("output/rates/")
      end
      
      task :arrests do
        DataUtils.generate_total_arrests_for_cities("output/rates/")
      end
    end
  end
  
  namespace :plot do
    task :state, :state do |t, args|
      args.with_defaults(:state => "valid")
      if args[:state] == "valid"
        States.reporting_states.each_key do |state|
          DataUtils.render_plots("data/rates/#{state}", "output/graphs/#{state}")
        end
        DataUtils.render_plots("data/rates/Total", "output/graphs/Total")
      elsif args[:state] == "all"
          States.all.each do |state|
            DataUtils.render_plots("data/rates/#{state}", "output/graphs/#{state}")
          end
      else
        DataUtils.render_plots("data/rates/#{args[:state]}","output/graphs/#{args[:state]}")
      end
    end
    
    task :city, :city do |t, args|
      args.with_defaults(:city => "valid")
      if args[:city] == "valid"
        Cities.reporting_cities.each_key do |city|
          DataUtils.render_plots("data/rates/cities/#{city}", "output/graphs/cities/#{city}")
        end
      else
        DataUtils.render_plots("data/rates/cities/#{args[:city]}","output/graphs/cities/ #{args[:city]}")
      end
    end
  end
  
  namespace :merge do
    task :city do
      require "java"
      require "lib/java/merger.jar"
      cityFolder = File.expand_path(File.join(File.dirname(__FILE__), "output", "graphs", "cities"))
      Cities.reporting_cities.each_key do |city|
        folder = File.join(cityFolder, city)
        files = Dir[File.join(folder, "*.pdf")]
        puts files
        Merger = Java::Juvenile.Merger
        merger = Merger.new city, "output/cities/#{city}.pdf", *files
        merger.merge
      end
    end
    
    task :state do
      require "java"
      require "lib/java/merger.jar"
      stateFolder = File.expand_path(File.join(File.dirname(__FILE__), "output", "graphs"))
      States.reporting_states.each_key do |state|
        folder = File.join(stateFolder, state)
        files = Dir[File.join(folder, "*.pdf")]
        puts files
        Merger = Java::Juvenile.Merger
        merger = Merger.new state, "output/states/#{state}.pdf", *files
        merger.merge
      end
    end
  end
end