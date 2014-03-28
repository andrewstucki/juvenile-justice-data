require "csv"
require "pp"
require "fileutils"

require "lib/ruby/states"
require "lib/ruby/cities"

class DataUtils
  @valid_years = (2005..2011).to_a
  @rate_variables = ["white_adult","white_juvenile","black_adult","black_juvenile","male_juvenile","female_juvenile"]

  class << self
    attr_reader :valid_years, :rate_variables

    def csv_rates(output_directory)
      FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)
            
      rates = Hash.new
      rates["white_juvenile"] = Hash.new
      rates["black_juvenile"] = Hash.new
      columns = Array.new
      Cities.reporting_cities.each_key do |city|
        city_rates = get_calculated_city_rates(city)
        rates["white_juvenile"][city] = Hash.new
        rates["black_juvenile"][city] = Hash.new
        city_rates.each_key do |offense|
          rates["white_juvenile"][city][offense] = city_rates[offense]["total_rate"]["white_juvenile"]
          rates["black_juvenile"][city][offense] = city_rates[offense]["total_rate"]["black_juvenile"]
          columns << offense if not columns.include? offense
        end
      end
      FileUtils.cd(output_directory) do
        CSV.open("White.csv", "wb") do |csv|
          csv << ["City"] + columns
          rates["white_juvenile"].each do |city, offenses|
            values = Array.new
            columns.each do |offense|
              values << offenses[offense]
            end
            csv << [city] + values
          end
        end
        CSV.open("Black.csv", "wb") do |csv|
          csv << ["City"] + columns
          rates["black_juvenile"].each do |city, offenses|
            values = Array.new
            columns.each do |offense|
              values << offenses[offense]
            end
            csv << [city] + values
          end
        end
      end
    end

    def get_offense_data(state, year, city=false)
      if city
        ars = CSV.read("data/offenses/#{year}/cities/#{state}.csv", :headers => true)
      else
        ars = CSV.read("data/offenses/#{year}/#{state}.csv", :headers => true)
      end
      offenses_data = Hash.new
      @rate_variables.each {|rate| offenses_data[rate] = Hash.new}

      ars.each do |entry|
        offenses_data["white_adult"][entry["OFFENSE"]] = entry["AdultWhite"].to_f
        offenses_data["black_adult"][entry["OFFENSE"]] = entry["AdultBlack"].to_f
        offenses_data["white_juvenile"][entry["OFFENSE"]] = entry["JuvenileWhite"].to_f
        offenses_data["black_juvenile"][entry["OFFENSE"]] = entry["JuvenileBlack"].to_f
        offenses_data["male_juvenile"][entry["OFFENSE"]] = entry["JuvenileMale"].to_f
        offenses_data["female_juvenile"][entry["OFFENSE"]] = entry["JuvenileFemale"].to_f
      end
      return offenses_data
    end

    def get_population_data(state, year)
      ars = CSV.read("data/raw/population/#{year}.csv", :headers => true)
      population_data = Hash.new
      ars.each do |entry|
        entry.map {|key, num| num.gsub!(',','') if num.is_a?(String)}
        if (entry["State"] == state)
          population_data["white_juvenile_male"] = entry["White Juvenile Male"].to_f
          population_data["white_juvenile_female"] = entry["White Juvenile Female"].to_f
          population_data["black_juvenile_male"] = entry["Black Juvenile Male"].to_f
          population_data["black_juvenile_female"] = entry["Black Juvenile Female"].to_f
          population_data["white_adult_male"] = entry["White Adult Male"].to_f
          population_data["white_adult_female"] = entry["White Adult Female"].to_f
          population_data["black_adult_male"] = entry["Black Adult Male"].to_f
          population_data["black_adult_female"] = entry["Black Adult Female"].to_f
          population_data["white_juvenile"] = population_data["white_juvenile_male"] + population_data["white_juvenile_female"]
          population_data["black_juvenile"] = population_data["black_juvenile_male"] + population_data["black_juvenile_female"]
          population_data["white_adult"] = population_data["white_adult_male"] + population_data["white_adult_female"]
          population_data["black_adult"] = population_data["black_adult_male"] + population_data["black_adult_female"]
          population_data["male_juvenile"] = population_data["black_juvenile_male"] + population_data["white_juvenile_male"]
          population_data["female_juvenile"] = population_data["black_juvenile_female"] + population_data["white_juvenile_female"]
          break
        end
      end
      return population_data
    end

    def generate_plot_files(state, output_directory)
      FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)

      calculated_rates = get_calculated_rates(state)

      FileUtils.cd(output_directory) do
        column_names = ["Year", "White Adult", "Black Adult", "White Juvenile", "Black Juvenile", "Male Juvenile", "Female Juvenile"]
        calculated_rates.each do |key, data|
          CSV.open("#{key}.csv", "wb") do |csv|
            csv << column_names
            data.each {|year, values| csv << [year, values["white_adult"], values["black_adult"], values["white_juvenile"], values["black_juvenile"], values["male_juvenile"], values["female_juvenile"]] unless year == "total_rate"}
          end

          file_data = Array.new

          File.open("#{key}.csv", "r") do |file|
            file_data = file.readlines
          end

          file_data = ["##{calculated_rates[key]['total_rate']}\n"] + file_data

          File.open("#{key}.csv", "wb") do |file|
            file_data.each { |line| file.write line }
          end
        end
      end
    end

    def generate_total_arrests_for_cities(output_directory)
      FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)
      totals = Hash.new
      populations = Hash.new
      crimes = ["Murder and manslaughter","Rape","Aggravated assault","Robbery"]
      @valid_years.each do |year|
        Cities.reporting_cities.each_key do |city|
          totals[city] ||= Hash.new
          ars = CSV.read("data/offenses/#{year}/cities/#{city}.csv", :headers => true)
          black_total = 0
          white_total = 0
          ars.each do |entry|
            next if !crimes.include?(entry["OFFENSE"])
            black_total += entry["JuvenileBlack"].to_f
            white_total += entry["JuvenileWhite"].to_f
          end
          population = get_city_population("", city, year)
          populations[city] ||= Hash.new
          populations[city][year] = {"Black" => population["black_juvenile"], "White" => population["white_juvenile"]}
          totals[city][year] = Hash.new
          totals[city][year]["Black"] = black_total
          totals[city][year]["White"] = white_total
        end
      end
      FileUtils.cd(output_directory) do
        CSV.open("totals.csv", "wb") do |csv|
          totals.each{|city,data| csv << [city] + @valid_years.map{|year| [data[year]["Black"], data[year]["White"]]}.flatten } 
        end
        CSV.open("populations.csv", "wb") do |csv|
          populations.each{|city,data| csv << [city] + @valid_years.map{|year| [data[year]["Black"], data[year]["White"]]}.flatten } 
        end
      end
    end

    def generate_city_plot_files(city, output_directory)
      FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)

      calculated_rates = get_calculated_city_rates(city)

      FileUtils.cd(output_directory) do
        column_names = ["Year", "White Adult", "Black Adult", "White Juvenile", "Black Juvenile", "Male Juvenile", "Female Juvenile"]
        calculated_rates.each do |key, data|
          CSV.open("#{key}.csv", "wb") do |csv|
            csv << column_names
            data.each {|year, values| csv << [year, values["white_adult"], values["black_adult"], values["white_juvenile"], values["black_juvenile"], values["male_juvenile"], values["female_juvenile"]] unless year == "total_rate"}
          end

          file_data = Array.new

          File.open("#{key}.csv", "r") do |file|
            file_data = file.readlines
          end

          file_data = ["##{calculated_rates[key]['total_rate']}\n"] + file_data

          File.open("#{key}.csv", "wb") do |file|
            file_data.each { |line| file.write line }
          end
        end
      end
    end

    def render_plots(input_directory, output_directory)
      input_files = Array.new
      current_directory = Dir.pwd
      FileUtils.mkdir_p(output_directory) unless File.directory?(output_directory)
      FileUtils.cd(input_directory) do
        input_files = Dir.glob("*")
      end
      FileUtils.cd(output_directory) do
        input_files.each do |input|
          input_file = File.join(current_directory, input_directory, input)
          puts input_file
          disparity = 0
          skip = false
          File.open(input_file) do |file|
            rates = file.readline
            rates[0] = ''
            total_rates = eval(rates)
            if total_rates["white_juvenile"] == 0
              disparity = "n/a"
            else
              disparity = (total_rates["black_juvenile"] / total_rates["white_juvenile"]).round(2)
              skip = false if total_rates["black_juvenile"] < 50 and total_rates["white_juvenile"] < 50
            end
          end

          category = File.basename(input, ".csv")
          next if skip or States.ignored_offenses.include? category
          outfile = "#{category}.pdf"
          graph_font = File.join(current_directory, "fonts/MuseoSlab,8")
          script = File.join(current_directory, "lib/gnuplot/plot.gnu")
          `gnuplot -e "graph_font='#{graph_font}';file='#{input_file}';category='#{category}';outfile='#{outfile}';disparity='Total RRI: #{disparity}'" #{script}`
        end
      end
    end

    def offense_dump(dta_file, dump_folder)
      FileUtils.mkdir_p(dump_folder) unless File.directory?(dump_folder)
      puts "Dumping #{dta_file}!"
      `r --no-save --no-restore --args #{dta_file} #{dump_folder} < lib/r/data.r`
    end

    def city_offense_dump(dta_file, dump_folder)
      FileUtils.mkdir_p(dump_folder) unless File.directory?(dump_folder)
      puts "Dumping #{dta_file}!"
      `r --no-save --no-restore --args #{dta_file} #{dump_folder} < lib/r/city.r`
    end

    def get_city_population(state, city, year)
      ars = CSV.read("data/raw/population/cities/#{year}.csv", :headers => true)
      population_data = Hash.new
      ars.each do |entry|
        entry.map {|key, num| num.gsub!(',','') if num.is_a?(String)}
        if (entry["City"] == city)
          puts entry
          population_data["white_juvenile_male"] = entry["White Juvenile Male"].to_f
          population_data["white_juvenile_female"] = entry["White Juvenile Female"].to_f
          population_data["black_juvenile_male"] = entry["Black Juvenile Male"].to_f
          population_data["black_juvenile_female"] = entry["Black Juvenile Female"].to_f
          population_data["white_adult_male"] = entry["White Adult Male"].to_f
          population_data["white_adult_female"] = entry["White Adult Female"].to_f
          population_data["black_adult_male"] = entry["Black Adult Male"].to_f
          population_data["black_adult_female"] = entry["Black Adult Female"].to_f
          population_data["white_juvenile"] = population_data["white_juvenile_male"] + population_data["white_juvenile_female"]
          population_data["black_juvenile"] = population_data["black_juvenile_male"] + population_data["black_juvenile_female"]
          population_data["white_adult"] = population_data["white_adult_male"] + population_data["white_adult_female"]
          population_data["black_adult"] = population_data["black_adult_male"] + population_data["black_adult_female"]
          population_data["male_juvenile"] = population_data["black_juvenile_male"] + population_data["white_juvenile_male"]
          population_data["female_juvenile"] = population_data["black_juvenile_female"] + population_data["white_juvenile_female"]
          break
        end
      end
      return population_data
      
      # input_files = Array.new
      # current_directory = Dir.pwd
      # data = Hash.new
      # FileUtils.cd("data/raw/population/ACS Summary/#{year}/#{state}") do
      #   text = File.open('geography.txt').read
      #   text.gsub!(/\r\n?/, "\n")
      #   line_record = 0
      #   text.each_line do |line|
      #     if city == "Nashville"
      #       match = (/Nashville-Davidson (balance), #{state}/ =~ line)
      #     else
      #       match = (/#{city} city, #{state}/ =~ line)
      #     end
      #     if not match.nil?
      #       line_match = /^ACSSF [A-Z]{2}[0-9]{9}(?<line_record>[0-9]{3}).*/.match(line)
      #       line_record = line_match['line_record'].to_i
      #       break
      #     end
      #   end
      #   puts state, city, year
      #   ars = CSV.read("#{state}.csv")
      #   city_data = ars[line_record-1][55, 62]
      #   data = {
      #     "white_juvenile_male" => city_data[4,2].inject{|sum, x| sum.to_i + x.to_i },
      #     "white_adult_male" => city_data[6,10].inject{|sum, x| sum.to_i + x.to_i },
      #     "white_juvenile_female" => city_data[19,2].inject{|sum, x| sum.to_i + x.to_i },
      #     "white_adult_female" => city_data[21,10].inject{|sum, x| sum.to_i + x.to_i },
      #     "black_juvenile_male" => city_data[35, 2].inject{|sum, x| sum.to_i + x.to_i },
      #     "black_adult_male" => city_data[37, 10].inject{|sum, x| sum.to_i + x.to_i },
      #     "black_juvenile_female" => city_data[50, 2].inject{|sum, x| sum.to_i + x.to_i },
      #     "black_adult_female" => city_data[52, 10].inject{|sum, x| sum.to_i + x.to_i }
      #   }
      #   data["white_juvenile"] = data["white_juvenile_male"] + data["white_juvenile_female"]
      #   data["black_juvenile"] = data["black_juvenile_male"] + data["black_juvenile_female"]
      #   data["white_adult"] = data["white_adult_male"] + data["white_adult_female"]
      #   data["black_adult"] = data["black_adult_male"] + data["black_adult_female"]
      #   data["male_juvenile"] = data["black_juvenile_male"] + data["white_juvenile_male"]
      #   data["female_juvenile"] = data["black_juvenile_female"] + data["white_juvenile_female"]
      # end
      # return data
    end


    private

    def get_calculated_rates(state)
      if state == "Total"
        return get_total_rates()
      else
        calculated_rates = Hash.new
        total_populations = Hash.new
        total_offenses = Hash.new
        @valid_years.each do |year|
          next if States.reporting_states[state].include? year
          population = get_population_data(state, year)
          offenses = get_offense_data(state, year)
          @rate_variables.each do |key|
            offenses[key].each_key do |offense|
              total_offenses[offense] ||= Hash.new

              calculated_rates[offense] ||= Hash.new
              calculated_rates[offense][year] ||= Hash.new
              calculated_rates[offense][year][key] = (offenses[key][offense] / population[key])*100000
              total_offenses[offense][key] ||= 0
              total_offenses[offense][key] += offenses[key][offense]
            end
            total_populations[key] ||= 0
            total_populations[key] += population[key]
          end
        end
        total_offenses.keys.each do |offense|
          calculated_rates[offense]["total_rate"] = Hash.new
          total_offenses[offense].keys.each do |key|
            calculated_rates[offense]["total_rate"][key] = (total_offenses[offense][key] /  total_populations[key])*100000
          end
        end
        return calculated_rates
      end
    end

    def get_calculated_city_rates(city)
      calculated_rates = Hash.new
      total_populations = Hash.new
      total_offenses = Hash.new
      @valid_years.each do |year|
        state = Cities.reporting_cities[city]
        next if city == "Boston" and year == 2005
        population = get_city_population(state, city, year)
        offenses = get_offense_data(city, year, true)
        @rate_variables.each do |key|
          offenses[key].each_key do |offense|
            total_offenses[offense] ||= Hash.new

            calculated_rates[offense] ||= Hash.new
            calculated_rates[offense][year] ||= Hash.new
            calculated_rates[offense][year][key] = (offenses[key][offense] / population[key])*100000
            total_offenses[offense][key] ||= 0
            total_offenses[offense][key] += offenses[key][offense]
          end
          total_populations[key] ||= 0
          total_populations[key] += population[key]
        end
      end
      total_offenses.keys.each do |offense|
        calculated_rates[offense]["total_rate"] = Hash.new
        total_offenses[offense].keys.each do |key|
          calculated_rates[offense]["total_rate"][key] = (total_offenses[offense][key] /  total_populations[key])*100000
        end
      end
      return calculated_rates
    end

    def get_total_rates
      calculated_rates = Hash.new
      total_populations = Hash.new
      total_offenses = Hash.new
      States.reporting_states.keys().each do |state|
        @valid_years.each do |year|
          next if States.reporting_states[state].include? year
          population = get_population_data(state, year)
          offenses = get_offense_data(state, year)
          @rate_variables.each do |key|
            offenses[key].each_key do |offense|
              total_offenses[offense] ||= Hash.new
              total_offenses[offense][year] ||= Hash.new
              total_offenses[offense][year][key] ||=  0
              total_offenses[offense][year][key] += offenses[key][offense]
              total_offenses[offense][key] ||= 0
              total_offenses[offense][key] += offenses[key][offense]
            end
            total_populations[year] ||= Hash.new
            total_populations[year][key] ||= 0
            total_populations[year][key] += population[key]
            total_populations[key] ||= 0
            total_populations[key] += population[key]
          end
        end
      end
      total_offenses.keys.each do |offense|
        calculated_rates[offense] ||= Hash.new
        total_offenses[offense].keys.each do |key|
          next if @valid_years.include? key
          @valid_years.each do |year|
            calculated_rates[offense][year] ||= Hash.new
            calculated_rates[offense][year][key] ||= 0
            next if total_offenses[offense][year].nil?
            next if total_populations[year][key].nil?
            calculated_rates[offense][year][key] = (total_offenses[offense][year][key] / total_populations[year][key])*100000
          end
          calculated_rates[offense]["total_rate"] ||= Hash.new
          calculated_rates[offense]["total_rate"][key] = (total_offenses[offense][key] /  total_populations[key])*100000
        end
      end
      return calculated_rates
    end

    def get_rates(state)
      rates = Hash.new
      @rate_variables.each {|rate| rates[rate] = Hash.new}
      @valid_years.each do |year|
        next if States.reporting_states[state].include? year
        population = get_population_data(state, year)
        offenses = get_offense_data(state, year)
        @rate_variables.each do |key|
          rates[key][year] = Hash.new
          rates[key][year]["population"] = population[key]
          offenses[key].each_key do |offense|
            rates[key][year][offense] = offenses[key][offense]
          end
        end
      end
      return rates
    end
  end
end
