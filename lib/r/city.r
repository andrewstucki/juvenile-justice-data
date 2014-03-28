library(foreign)
library(data.table)

args <- commandArgs(TRUE)
filename <- args[1]
directory <- args[2]

load_data = function(filename) {
  data <- read.dta(filename)
  data <- transform(data,
    JW = ifelse(JW == 99999, 0, JW),
    AB = ifelse(AB == 99999, 0, AB),
    JB = ifelse(JB == 99999, 0, JB),
    AW = ifelse(AW == 99999, 0, AW),
    M0_9 = ifelse(M0_9 == 99999, 0, M0_9),
    M10_12 = ifelse(M10_12 == 99999, 0, M10_12),
    M13_14 = ifelse(M13_14 == 99999, 0, M13_14),
    M15 = ifelse(M15 == 99999, 0, M15),
    M16 = ifelse(M16 == 99999, 0, M16),
    M17 = ifelse(M17 == 99999, 0, M17),
    M18 = ifelse(M18 == 99999, 0, M18),
    M19 = ifelse(M19 == 99999, 0, M19),
    M20 = ifelse(M20 == 99999, 0, M20),
    M21 = ifelse(M21 == 99999, 0, M21),
    M22 = ifelse(M22 == 99999, 0, M22),
    M23 = ifelse(M23 == 99999, 0, M23),
    M24 = ifelse(M24 == 99999, 0, M24),
    M25_29 = ifelse(M25_29 == 99999, 0, M25_29),
    M30_34 = ifelse(M30_34 == 99999, 0, M30_34),
    M35_39 = ifelse(M35_39 == 99999, 0, M35_39),
    M40_44 = ifelse(M40_44 == 99999, 0, M40_44),
    M45_49 = ifelse(M45_49 == 99999, 0, M45_49),
    M50_54 = ifelse(M50_54 == 99999, 0, M50_54),
    M55_59 = ifelse(M55_59 == 99999, 0, M55_59),
    M60_64 = ifelse(M60_64 == 99999, 0, M60_64),
    M65 = ifelse(M65 == 99999, 0, M65),
    F0_9 = ifelse(F0_9 == 99999, 0, F0_9),
    F10_12 = ifelse(F10_12 == 99999, 0, F10_12),
    F13_14 = ifelse(F13_14 == 99999, 0, F13_14),
    F15 = ifelse(F15 == 99999, 0, F15),
    F16 = ifelse(F16 == 99999, 0, F16),
    F17 = ifelse(F17 == 99999, 0, F17),
    F18 = ifelse(F18 == 99999, 0, F18),
    F19 = ifelse(F19 == 99999, 0, F19),
    F20 = ifelse(F20 == 99999, 0, F20),
    F21 = ifelse(F21 == 99999, 0, F21),
    F22 = ifelse(F22 == 99999, 0, F22),
    F23 = ifelse(F23 == 99999, 0, F23),
    F24 = ifelse(F24 == 99999, 0, F24),
    F25_29 = ifelse(F25_29 == 99999, 0, F25_29),
    F30_34 = ifelse(F30_34 == 99999, 0, F30_34),
    F35_39 = ifelse(F35_39 == 99999, 0, F35_39),
    F40_44 = ifelse(F40_44 == 99999, 0, F40_44),
    F45_49 = ifelse(F45_49 == 99999, 0, F45_49),
    F50_54 = ifelse(F50_54 == 99999, 0, F50_54),
    F55_59 = ifelse(F55_59 == 99999, 0, F55_59),
    F60_64 = ifelse(F60_64 == 99999, 0, F60_64),
    F65 = ifelse(F65 == 99999, 0, F65)
  )
  data <- transform(data,
    JW = ifelse(JW == 99998, 0, JW),
    AB = ifelse(AB == 99998, 0, AB),
    JB = ifelse(JB == 99998, 0, JB),
    AW = ifelse(AW == 99998, 0, AW),
    M0_9 = ifelse(M0_9 == 99998, 0, M0_9),
    M10_12 = ifelse(M10_12 == 99998, 0, M10_12),
    M13_14 = ifelse(M13_14 == 99998, 0, M13_14),
    M15 = ifelse(M15 == 99998, 0, M15),
    M16 = ifelse(M16 == 99998, 0, M16),
    M17 = ifelse(M17 == 99998, 0, M17),
    M18 = ifelse(M18 == 99998, 0, M18),
    M19 = ifelse(M19 == 99998, 0, M19),
    M20 = ifelse(M20 == 99998, 0, M20),
    M21 = ifelse(M21 == 99998, 0, M21),
    M22 = ifelse(M22 == 99998, 0, M22),
    M23 = ifelse(M23 == 99998, 0, M23),
    M24 = ifelse(M24 == 99998, 0, M24),
    M25_29 = ifelse(M25_29 == 99998, 0, M25_29),
    M30_34 = ifelse(M30_34 == 99998, 0, M30_34),
    M35_39 = ifelse(M35_39 == 99998, 0, M35_39),
    M40_44 = ifelse(M40_44 == 99998, 0, M40_44),
    M45_49 = ifelse(M45_49 == 99998, 0, M45_49),
    M50_54 = ifelse(M50_54 == 99998, 0, M50_54),
    M55_59 = ifelse(M55_59 == 99998, 0, M55_59),
    M60_64 = ifelse(M60_64 == 99998, 0, M60_64),
    M65 = ifelse(M65 == 99998, 0, M65),
    F0_9 = ifelse(F0_9 == 99998, 0, F0_9),
    F10_12 = ifelse(F10_12 == 99998, 0, F10_12),
    F13_14 = ifelse(F13_14 == 99998, 0, F13_14),
    F15 = ifelse(F15 == 99998, 0, F15),
    F16 = ifelse(F16 == 99998, 0, F16),
    F17 = ifelse(F17 == 99998, 0, F17),
    F18 = ifelse(F18 == 99998, 0, F18),
    F19 = ifelse(F19 == 99998, 0, F19),
    F20 = ifelse(F20 == 99998, 0, F20),
    F21 = ifelse(F21 == 99998, 0, F21),
    F22 = ifelse(F22 == 99998, 0, F22),
    F23 = ifelse(F23 == 99998, 0, F23),
    F24 = ifelse(F24 == 99998, 0, F24),
    F25_29 = ifelse(F25_29 == 99998, 0, F25_29),
    F30_34 = ifelse(F30_34 == 99998, 0, F30_34),
    F35_39 = ifelse(F35_39 == 99998, 0, F35_39),
    F40_44 = ifelse(F40_44 == 99998, 0, F40_44),
    F45_49 = ifelse(F45_49 == 99998, 0, F45_49),
    F50_54 = ifelse(F50_54 == 99998, 0, F50_54),
    F55_59 = ifelse(F55_59 == 99998, 0, F55_59),
    F60_64 = ifelse(F60_64 == 99998, 0, F60_64),
    F65 = ifelse(F65 == 99998, 0, F65)
  )
  return(data)
}

generate_tables = function(data) {
  dataTable <- data.table(data)
  table <- dataTable[,list(
    AdultBlack=sum(AB),
    AdultWhite=sum(AW),
    JuvenileBlack=sum(JB),
    JuvenileWhite=sum(JW),
    JuvenileFemale=sum(F0_9,F10_12,F13_14,F15,F16,F17),
    JuvenileMale=sum(M0_9,M10_12,M13_14,M15,M16,M17)),
    by=c('STATE','OFFENSE')
  ]
  table <- offense_columns(table)
  return(table)
}

generate_agency_tables = function(data, state, agency) {
  dataTable <- data.table(data)
  table <- dataTable[which((dataTable$AGENCY == agency) & (dataTable$STATE == state)),list(
    AdultBlack=sum(AB),
    AdultWhite=sum(AW),
    JuvenileBlack=sum(JB),
    JuvenileWhite=sum(JW),
    JuvenileFemale=sum(F0_9,F10_12,F13_14,F15,F16,F17),
    JuvenileMale=sum(M0_9,M10_12,M13_14,M15,M16,M17)),
    by=c('STATE','OFFENSE')
  ]
  table <- offense_columns(table)
  return(table)
}

states <- c(
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
)

dump_states = function(data, directory) {
  old_directory <- getwd()
  setwd(directory)
  for (state in states) {
    write.csv(data[which(data$STATE == state),], sprintf("%s.csv", state), row.names=FALSE)
  }
  setwd(old_directory)
}

offense_columns = function(data) {
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "01A", "Murder and manslaughter", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "01B", "Manslaughter by negligence", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "02", "Rape", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "03", "Robbery", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "04", "Aggravated assault", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "05", "Burglary", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "06", "Larceny", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "07", "Motor vehicle theft", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "08", "Other assaults", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "09", "Arson", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "10", "Forgery and counterfeiting", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "11", "Fraud", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "12", "Embezzlement", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "13", "Stolen property", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "14", "Vandalism", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "15", "Weapons", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "16", "Prostitution", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "17", "Sex offenses", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18", "Total Drug Violations", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "180", "Sale (subtotal)", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "185", "Possession (subtotal)", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18A", "Sale-Opiates", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18B", "Sale-Marijuana", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18C", "Sale-Synthetic narcotics", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18D", "Sale-Other drugs", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18E", "Possession-Opiates", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18F", "Possession-Marijuana", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18G", "Possession-Synthetic narcotics", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "18H", "Possession-Other drugs", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "19", "Gambling (total)", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "19A", "Bookmaking (horse and sports)", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "19B", "Number and lottery", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "19C", "All other gambling", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "20", "Family offenses", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "21", "DUI", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "22", "Liquor", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "23", "Drunkenness", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "24", "Disorderly conduct", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "25", "Vagrancy", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "26", "All other non-traffic offenses", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "27", "Suspicion", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "28", "Curfew and Loitering", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "29", "Runaways", OFFENSE))
  data <- transform(data, OFFENSE = ifelse(OFFENSE == "998", "Unclassified Arrest", OFFENSE))
  return(data)
}

dump_agency = function(data, agency, directory) {
  old_directory <- getwd()
  setwd(directory)
  write.csv(data, sprintf("%s.csv", agency), row.names=FALSE)
  setwd(old_directory)
}

tables <- load_data(filename)

agencyTables <- generate_agency_tables(tables, "California", "LOS ANGELES")
dump_agency(agencyTables, "Los Angeles", directory)

agencyTables <- generate_agency_tables(tables, "California", "RIVERSIDE")
dump_agency(agencyTables, "Riverside", directory)

agencyTables <- generate_agency_tables(tables, "California", "SAN FRANCISCO")
dump_agency(agencyTables, "San Francisco", directory)

agencyTables <- generate_agency_tables(tables, "California", "SAN DIEGO")
dump_agency(agencyTables, "San Diego", directory)

agencyTables <- generate_agency_tables(tables, "California", "SACRAMENTO")
dump_agency(agencyTables, "Sacramento", directory)

agencyTables <- generate_agency_tables(tables, "California", "SAN JOSE")
dump_agency(agencyTables, "San Jose", directory)

agencyTables <- generate_agency_tables(tables, "Texas", "DALLAS")
dump_agency(agencyTables, "Dallas", directory)

agencyTables <- generate_agency_tables(tables, "Texas", "HOUSTON")
dump_agency(agencyTables, "Houston", directory)

agencyTables <- generate_agency_tables(tables, "Texas", "SAN ANTONIO")
dump_agency(agencyTables, "San Antonio", directory)

agencyTables <- generate_agency_tables(tables, "Pennsylvania", "PHILADELPHIA")
dump_agency(agencyTables, "Philadelphia", directory)

agencyTables <- generate_agency_tables(tables, "Pennsylvania", "PITTSBURGH")
dump_agency(agencyTables, "Pittsburgh", directory)

agencyTables <- generate_agency_tables(tables, "Texas", "FORT WORTH")
dump_agency(agencyTables, "Fort Worth", directory)

agencyTables <- generate_agency_tables(tables, "Massachusetts", "BOSTON")
dump_agency(agencyTables, "Boston", directory)

agencyTables <- generate_agency_tables(tables, "Michigan", "DETROIT")
dump_agency(agencyTables, "Detroit", directory)

agencyTables <- generate_agency_tables(tables, "Arizona", "PHOENIX")
dump_agency(agencyTables, "Phoenix", directory)

agencyTables <- generate_agency_tables(tables, "Minnesota", "MINNEAPOLIS")
dump_agency(agencyTables, "Minneapolis", directory)

agencyTables <- generate_agency_tables(tables, "Missouri", "ST. LOUIS")
dump_agency(agencyTables, "St. Louis", directory)

agencyTables <- generate_agency_tables(tables, "Maryland", "BALTIMORE")
dump_agency(agencyTables, "Baltimore", directory)

agencyTables <- generate_agency_tables(tables, "Colorado", "DENVER")
dump_agency(agencyTables, "Denver", directory)

agencyTables <- generate_agency_tables(tables, "Oregon", "PORTLAND")
dump_agency(agencyTables, "Portland", directory)

agencyTables <- generate_agency_tables(tables, "Missouri", "KANSAS CITY")
dump_agency(agencyTables, "Kansas City", directory)

agencyTables <- generate_agency_tables(tables, "Ohio", "COLUMBUS")
dump_agency(agencyTables, "Columbus", directory)

agencyTables <- generate_agency_tables(tables, "Texas", "AUSTIN")
dump_agency(agencyTables, "Austin", directory)

agencyTables <- generate_agency_tables(tables, "Tennessee", "NASHVILLE")
dump_agency(agencyTables, "Nashville", directory)

agencyTables <- generate_agency_tables(tables, "Virginia", "VIRGINIA BEACH")
dump_agency(agencyTables, "Virginia Beach", directory)

agencyTables <- generate_agency_tables(tables, "Rhode Island", "PROVIDENCE")
dump_agency(agencyTables, "Providence", directory)

agencyTables <- generate_agency_tables(tables, "Wisconsin", "MILWAUKEE")
dump_agency(agencyTables, "Milwaukee", directory)

agencyTables <- generate_agency_tables(tables, "California", "OAKLAND")
dump_agency(agencyTables, "Oakland", directory)

agencyTables <- generate_agency_tables(tables, "Arizona", "MESA")
dump_agency(agencyTables, "Mesa", directory)

agencyTables <- generate_agency_tables(tables, "Georgia", "ATLANTA")
dump_agency(agencyTables, "Atlanta", directory)

agencyTables <- generate_agency_tables(tables, "Tennessee", "MEMPHIS")
dump_agency(agencyTables, "Memphis", directory)

agencyTables <- generate_agency_tables(tables, "Oklahoma", "OKLAHOMA CITY")
dump_agency(agencyTables, "Oklahoma City", directory)

agencyTables <- generate_agency_tables(tables, "Kentucky", "LOUISVILLE")
dump_agency(agencyTables, "Louisville", directory)

agencyTables <- generate_agency_tables(tables, "Virginia", "RICHMOND")
dump_agency(agencyTables, "Richmond", directory)

agencyTables <- generate_agency_tables(tables, "Louisiana", "NEW ORLEANS")
dump_agency(agencyTables, "New Orleans", directory)

agencyTables <- generate_agency_tables(tables, "Connecticut", "HARTFORD")
dump_agency(agencyTables, "Hartford", directory)

agencyTables <- generate_agency_tables(tables, "North Carolina", "RALEIGH")
dump_agency(agencyTables, "Raleigh", directory)

agencyTables <- generate_agency_tables(tables, "Alabama", "BIRMINGHAM")
dump_agency(agencyTables, "Birmingham", directory)

agencyTables <- generate_agency_tables(tables, "New York", "BUFFALO")
dump_agency(agencyTables, "Buffalo", directory)

agencyTables <- generate_agency_tables(tables, "Utah", "SALT LAKE CITY")
dump_agency(agencyTables, "Salt Lake City", directory)