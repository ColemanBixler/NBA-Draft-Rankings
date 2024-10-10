# The Best Drafting NBA Teams

## Project Description
This project finds what teams have drafted in the past 20 years (2003-2024) the best based on the advanced statistic LEBRON?

## LEBRON Explanation
LEBRON: Luck-adjusted player Estimate using a Box prior Regularized ON-off 
"Put simply, LEBRON evaluates a player’s contributions using the box score  (weighted using boxPIPM’s weightings stabilized using Offensive Archetypes) and advanced on/off calculations (using Luck-Adjusted RAPM methodology) for a holistic evaluation of player impact per 100 possessions on-court." (https://www.bball-index.com/lebron-introduction/)

## Methodology

### Data Sources
- LEBRON Data taken from bball-index.com
- Draft Data taken from basketball-reference.com

### DraftLBPY
Because of the variance of length in NBA Careers, I decided it would be better to calculate players' LEBRON per year (LBPY). I then decided to compare each players LBPY to other players picked at their pick (to measure the return value for their given expectations) and also to other players in their draft (to measure how good a player was compared to the rest of their draft). I then add them to get my statistic **DraftLBPY**.

- LBPY = mean LEBRON over each season of a player's career
- PickLBPY = stdevs away from mean LBPY for all players picked at that pick
- YearLBPY = stdevs away from mean LBPY of all players in their draft
- DraftLBPY = PickLBPY + YearLBPY

### Scoring Teams
To score how well teams draft, I decided to take the average of all of their picks and then rank them based on that.

## Results
1. HOU = 0.6202673 
2. OKC = 0.4728391 
3. DEN = 0.466735 
4. DAL = 0.3961242 
5. ORL = 0.3100406 
6. TOR = 0.2402083 
7. SAS = 0.2191345 
8. MEM = 0.205705 
9. SAC = 0.1795842 
10. PHI = 0.145455 
11. CLE = 0.09752558 
12. BRK = 0.07171027 
13. NOP = 0.0716746 
14. MIN = 0.06964299 
15. ATL = 0.05463142 
16. CHA = 0.02609096 
17. LAL = -0.02171939 
18. UTA = -0.07013121 
19. GSW = -0.09108246 
20. MIL = -0.1107418 
21. WAS = -0.1301454 
22. IND = -0.1670979 
23. PHO = -0.1702435 
24. MIA = -0.1709168 
25. BOS = -0.2542258 
26. LAC = -0.3056889 
27. CHI = -0.3118534 
29. NYK = -0.4342879 
30. POR = -0.729073

### Other Results
- If one wants to see how each player stacks up, I have included the data frame used in the calculations as a csv titled "drafts_total_data.csv"
- If one wants to see how each team fairs each year, I have included a plot of that called "Yearly Draft Rankings.png" where one can see that.

## Takeaways 
I was surprised that Houston was so much higher than everyone else (considering their best player over this period was James Harden who was acquired through trade). Further, I was VERY shocked by Boston being 25th considering that franchise drafted some of the best players in the league (though, many of their best players today have come from trades). 

## Future Improvements
Denver was number 3 which made sense to me because Jokic is the best player in terms of DraftLBPY by far. However, I realized part of this was also because the DraftLBPY was very high for Rudy Gobert and Donovan Mitchell too, both of whom were traded to the Utah Jazz (rank 18) on draft night. I should refine my data to instead have which team they left with on draft night instead of who they were directly drafted by. This would be a better indicator of how well the team drafted in my opinion.
