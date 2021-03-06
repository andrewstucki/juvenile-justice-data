class States
  class << self
    def all_states
      return [
        "Alabama",
        "Alaska",
        "Arizona",
        "Arkansas",
        "California",
        "Colorado",
        "Connecticut",
        "Delaware",
        "District of Columbia",
        "Florida",
        "Georgia",
        "Hawaii",
        "Idaho",
        "Illinois",
        "Indiana",
        "Iowa",
        "Kansas",
        "Kentucky",
        "Louisiana",
        "Maine",
        "Maryland",
        "Massachusetts",
        "Michigan",
        "Minnesota",
        "Mississippi",
        "Missouri",
        "Montana",
        "Nebraska",
        "Nevada",
        "New Hampshire",
        "New Jersey",
        "New Mexico",
        "New York",
        "North Carolina",
        "North Dakota",
        "Ohio",
        "Oklahoma",
        "Oregon",
        "Pennsylvania",
        "Rhode Island",
        "South Carolina",
        "South Dakota",
        "Tennessee",
        "Texas",
        "Utah",
        "Vermont",
        "Virginia",
        "Washington",
        "West Virginia",
        "Wisconsin",
        "Wyoming"
      ]
    end
    
    def reporting_states
      return {
        "Alaska" => [],
        "Arizona" => [],
        "Arkansas" => [2004, 2007],
        "California" => [],
        "Colorado" => [],
        "Connecticut" => [],
        "Delaware" => [],
        "Hawaii" => [],
        "Idaho" => [],
        "Iowa" => [],
        "Maine" => [],
        "Maryland" => [],
        "Massachusetts" => [2004, 2005],
        "Michigan" => [],
        "Minnesota" => [],
        "Missouri" => [],
        "Montana" => [2004],
        "Nebraska" => [],
        "Nevada" => [],
        "New Jersey" => [],
        "New Mexico" => [2005, 2006, 2007, 2009],
        "New York" => [],
        "North Carolina" => [2004, 2007, 2008],
        "North Dakota" => [2004],
        "Oklahoma" => [],
        "Oregon" => [],
        "Pennsylvania" => [],
        "Rhode Island" => [],
        "South Carolina" => [],
        "South Dakota" => [2004, 2005, 2006, 2006, 2008],
        "Tennessee" => [],
        "Texas" => [],
        "Utah" => [],
        "Vermont" => [],
        "Virginia" => [],
        "West Virginia" => [2009],
        "Wisconsin" => [],
        "Wyoming" => []
      }
    end
    
    def ignored_offenses
      return [
        "Bookmaking (horse and sports)",
        "Drunkenness",
        "All other gambling",
        "Gambling (total)",
        "Number and lottery",
        "Unclassified Arrest",
        "Manslaughter by negligence",
        "Suspicion",
        "Vagrancy",
        "All other non-traffic offenses",
        "Sale (subtotal)",
        "Possession (subtotal)",
        "Total Drug Violations",
        "Possession-Other drugs",
        "Sale-Other drugs",
        "Possession-Synthetic narcotics",
        "Sale-Synthetic narcotics",
        "Forgery and counterfeiting",
        "Fraud",
        "Family offenses",
        "DUI",
        "Embezzlement",
        "Arson"
      ]
    end
  end
end