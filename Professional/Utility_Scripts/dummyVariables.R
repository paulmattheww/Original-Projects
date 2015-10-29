# CREATE DUMMY VARIABLES FOR CORRELATIONS, THEN FILTER OUT 
library(dummies) 
weekdayDummies <- dummy('WEEKDAY',OMEGA)
OMEGA <- cbind(OMEGA, weekdayDummies)
seasonDummies <- dummy('SEASON', OMEGA)
OMEGA <- cbind(OMEGA, seasonDummies)
monthDummies <- dummy('MONTH', OMEGA)
OMEGA <- cbind(OMEGA, monthDummies)
