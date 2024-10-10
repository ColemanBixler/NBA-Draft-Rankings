# Import libraries for, respectively, reading in data and plotting
library("readxl")
library(ggplot2)
library(data.table)
library(comprehenr)

# Read in the data of each draft 
## All mentions of SEA has been replaced with OKC, NJN with BRK, NOK/NOH with NOP, and CHO with CHA
draft04 <- readxl::read_xls("Drafts/2004.xls", col_names = TRUE, skip = 1)
draft05 <- readxl::read_xls("Drafts/2005.xls", col_names = TRUE, skip = 1)
draft06 <- readxl::read_xls("Drafts/2006.xls", col_names = TRUE, skip = 1)
draft07 <- readxl::read_xls("Drafts/2007.xls", col_names = TRUE, skip = 1)
draft08 <- readxl::read_xls("Drafts/2008.xls", col_names = TRUE, skip = 1)
draft09 <- readxl::read_xls("Drafts/2009.xls", col_names = TRUE, skip = 1)
draft10 <- readxl::read_xls("Drafts/2010.xls", col_names = TRUE, skip = 1)
draft11 <- readxl::read_xls("Drafts/2011.xls", col_names = TRUE, skip = 1)
draft12 <- readxl::read_xls("Drafts/2012.xls", col_names = TRUE, skip = 1)
draft13 <- readxl::read_xls("Drafts/2013.xls", col_names = TRUE, skip = 1)
draft14 <- readxl::read_xls("Drafts/2014.xls", col_names = TRUE, skip = 1)
draft15 <- readxl::read_xls("Drafts/2015.xls", col_names = TRUE, skip = 1)
draft16 <- readxl::read_xls("Drafts/2016.xls", col_names = TRUE, skip = 1)
draft17 <- readxl::read_xls("Drafts/2017.xls", col_names = TRUE, skip = 1)
draft18 <- readxl::read_xls("Drafts/2018.xls", col_names = TRUE, skip = 1)
draft19 <- readxl::read_xls("Drafts/2019.xls", col_names = TRUE, skip = 1)
draft20 <- readxl::read_xls("Drafts/2020.xls", col_names = TRUE, skip = 1)
draft21 <- readxl::read_xls("Drafts/2021.xls", col_names = TRUE, skip = 1)
draft22 <- readxl::read_xls("Drafts/2022.xls", col_names = TRUE, skip = 1)
draft23 <- readxl::read_xls("Drafts/2023.xls", col_names = TRUE, skip = 1)

# Read in LEBRON data since 2010 (data is not available for earlier years)
lebron <- readxl::read_xlsx("lebron-1024.xlsx", col_names = TRUE)

# Initialize list of all draft datasets
drafts = list(draft04, draft05, draft06, draft07, draft08, draft09, draft10, 
           draft11, draft12, draft13, draft14, draft15, draft16, draft17, 
           draft18, draft19,draft20, draft21, draft22, draft23)

# Combine each draft dataset to one dataset
drafts_total_data <- rbindlist(drafts, idcol = "DraftIndex")

# Remove "Rk" column for less clutter
drafts_total_data <- drafts_total_data[, -2]

# Initalize LEBRON/Year as 0
drafts_total_data$LBPY <- 0

# Replace special characters with their standard keyboard equivalent 
subs = c(c("À", "A"), c("Á", "A"), c("Ä", "A"), c("Â", "A"), c("Ã", "A"), c("Å", "A"), c("Æ", "AE"), c("ä", "a"), c("à", "a"), c("á", "a"), c("â", "a"), c("ã", "a"), c("å", "a"), c("æ", "ae"), c("Ç", "C"), c("ç", "c"), c("č", "c"), c("ć", "c"), c("Ð", "D"), c("ð", "d"), c("Ë", "E"), c("È", "E"), c("É", "E"), c("Ê", "E"), c("ë", "e"), c("è", "e"), c("é", "e"), c("ê", "e"), c("Ï", "I"), c("Ì", "I"), c("Í", "I"), c("Î", "I"), c("ï", "i"), c("ì", "i"), c("í", "i"), c("î", "i"), c("Ñ", "N"), c("ñ", "n"), c("Ö", "O"), c("Ò", "O"), c("Ó", "O"), c("Ô", "O"), c("Õ", "O"), c("Ø", "O"), c("Œ", "OE"), c("ö", "o"), c("ò", "o"), c("ó", "o"), c("ô", "o"), c("õ", "o"), c("ø", "o"), c("œ", "oe"), c("Š", "S"), c("ß", "sz"), c("š", "s"), c("Þ", "T"), c("þ", "t"), c("Ü", "U"), c("Ù", "U"), c("Ú", "U"), c("Û", "U"), c("ü", "u"), c("ù", "u"), c("ú", "u"), c("û", "u"), c("Ÿ", "Y"), c("Ý", "Y"), c("ÿ", "y"), c("ý", "y"), c("¨",	""), c("ˆ", ""), c("˜", ""), c("´", ""), c("¯", ""), c("‾", ""), c("¸", ""))
for(k in seq(1, length(subs), 2)) {
  drafts_total_data$Player = stringr::str_replace_all(drafts_total_data$Player, pattern = subs[k], replacement = subs[k+1])
}

# Set each player's LEBRON / Year as their average LEBRON
for(i in 1:60) {
  for(j in 1:20) {
    name = drafts_total_data[drafts_total_data$DraftIndex == j & drafts_total_data$Pk == i]$Player
    if(length(name) == 0) next
    lbpy <- mean(subset(lebron, lebron$Player == name)$LEBRON)
    drafts_total_data[Player == name]$LBPY <- lbpy
  }
}

# Remove 0's (Players with no PT)
is.na(drafts_total_data$LBPY) <- !(drafts_total_data$LBPY)

# Initialize LEBRON/Year in compared to other players picked at a certain pick number
drafts_total_data$PickLBPY <- 0

# Group each player by pick
picks = to_list(for(i in 1:60) subset(drafts_total_data, Pk == i, select = c(Tm, Player, LBPY)))

# Initialize the means of each pick (expected value given pick number)
pick_means = c(1:60)

# Find the z-score of each player's LBPY in regards to their pick number and set as their PickLBPY
for(i in 1:60) {
  pick = picks[[i]]
  µ = mean(pick$LBPY, na.rm = TRUE)
  s = sd(pick$LBPY, na.rm = TRUE)
  pick_means[i] = µ
  for(j in 1:20) {
    player = pick[j]
    name = player$Player
    if(is.na(name)) next
    pv = (player$LBPY-µ)/s
    drafts_total_data[Player == name]$PickLBPY[1] = pv
  }
}

# Initialize the LEBRON/Year for each player in comparison to each player in their draft
drafts_total_data$YearLBPY <- 0

# Initialize the total LEBRON/Year that combines both the YearLBPY and the PickLBPY
drafts_total_data$DraftLBPY <- 0

# Group each player by year
years = to_list(for(i in c(1:20)) subset(drafts_total_data, drafts_total_data$DraftIndex == i, select = c(Pk, Tm, Player, LBPY)))

# Find the z-score of each player's LBPY in regards to their draft year and set as their YearLBPY
for(i in 1:20) {
  year = years[[i]]
  µ = mean(year$LBPY, na.rm = TRUE)
  s = sd(year$LBPY, na.rm = TRUE)
  for(j in 1:60) {
    player = subset(year, year$Pk == j, select = c(Tm, Player, LBPY))
    name = player$Player
    if(length(name) == 0) next
    yv = (player$LBPY-µ)/s
    drafts_total_data[Player == name]$YearLBPY[1] = yv
    
    # Calculate a player's DraftLBPY as the sum of their PickLBPY and their YearLBPY
    pv = drafts_total_data[Player == name]$PickLBPY[1]
    drafts_total_data[Player == name]$DraftLBPY[1] = pv + yv
  }
}

# Initialize the list of all NBA cities
cities = c("ATL", "BOS", "BRK", "CHA", "CHI", "CLE", "DAL", "DEN", "DET", "GSW", 
           "HOU", "IND", "LAC", "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", 
           "OKC", "ORL", "PHI", "PHO", "POR", "SAC", "SAS", "TOR", "UTA", "WAS")

# Group Players by Team they were drafted to
## Does not consider trades on draft night; however, that could be arranged
teams = to_list(for(city in cities) subset(drafts_total_data, Tm == city, select = c(Tm, Player, LBPY, PickLBPY, YearLBPY, DraftLBPY)))

# Initialize each the average DraftLBPY for each team as their AvgDLBPY
team_scores = data.frame(Team = c(1:30, ""), AvgDLBPY = c(1:30, 0))

# Find the average DraftLBPY for each team and set that as their AvgDLBPY
for(i in 1:30) {
  team = teams[[i]]
  team_scores$Team[i] = team$Tm[1]
  team_scores$AvgDLBPY[i] = mean(team$DraftLBPY, na.rm = TRUE)
}

# Remove unwanted blank value
team_scores = team_scores[1:30,]

# Find the order of each team based on their score
o <- order(team_scores$AvgDLBPY, decreasing = TRUE)

# Print out the ranking of each team based of the average of their drafted players' DLBPY
rank = 1
for(i in o) {
  cat(rank, ":",  team_scores[i,]$Team, "=", team_scores[i,]$AvgDLBPY, "\n")
  rank = rank + 1
}

# Import team's colors
colors = readxl::read_xlsx("colors.xlsx", col_names = TRUE, skip = 1)

# Merge colors with the data holding the calculations to assign colors for the players
plot_data = merge(drafts_total_data, colors, by = "Tm")

# Plot each teams DraftLBPY each year
ggplot(data = plot_data) +
  aes(x = DraftIndex + 2003, y = DraftLBPY, color = Tm) +
  scale_color_manual(values = colors$Color1) +
  geom_point(fill = plot_data$Color2, stroke = 1.5, shape = 21) +
  labs(title = "Best Selections based on DraftLBPY for each draft", x = "DraftYear")
# Print out the ranking of each team based of the average of their drafted players' DLBPY
## Moved to end to appear last in command line
rank = 1
for(i in o) {
  cat(rank, ":",  team_scores[i,]$Team, "=", team_scores[i,]$AvgDLBPY, "\n")
  rank = rank + 1
}



