# Optimization R&D
cat('A student must pass final exams
    in French and Calculus. The student can spend time listening to tapes in the language lab or
    meeting with a math tutor. But, the student has a limited financial budget and a busy
    schedule. How much time should the student spend in lab or with a tutor in order to get the
    highest possible total score and pass both exams?
    
    Model Parameters

      Available Budget 100 dollars
      Available Time 11 hours
      Price of Language Lab 5.00 dollars/hour
      Price of Math Tutor 15.00 dollars/hour
      Current French Grade 40 points
      Current Calculus Grade 40 points
      Passing Grade 50 points
      Points per Language Lab Hour 3.33 points
      Points per Math Tutor Hour 5.00 points
      Maximum Lab Time 8.00 hours
      Maximum Tutoring Time 7.00 hours')

# ##Time spent in language lab
# x[1]=languagelab
# 
# ##Time spent with math tutor
# x[2]=mathtutor

library(optimx)


grade_max = function(x) {
  ##Enumerate constraints
  max_budget = 100
  time_avail = 11 #hrs
  price_lang_lab = 5
  price_math_tut = 15
  current_french = current_calc = 40
  min_passing_grade = 50
  lang_avilable_time = 8
  math_available_time = 7
  
  french_hours = ifelse(x[1]<=0, 0, x[1])
  math_hours = ifelse(x[2]<=0, 0, x[2])
  
  ##Maximize objective function
  french_grade_expected = (current_french+(3.33*french_hours))
  calc_grade_expected = (current_calc+(5*math_hours))
  y = french_grade_expected + calc_grade_expected
  
  ##Implement constraints
  if((french_hours <= 0) | (math_hours <= 0) | (y >= 200) |
     french_hours + math_hours > time_avail | #time avail for student
     french_hours > lang_avilable_time | #lang lab constraint
     math_hours > math_available_time | #math tutor constraint
     french_grade_expected < min_passing_grade | #Passing grade lang
     calc_grade_expected < min_passing_grade | #Passing grade lang
     price_lang_lab*french_hours + price_math_tut*math_hours > max_budget | #budget constraint
     current_french+(3.33*french_hours) > 100 | #can't get more than 100
     current_calc+(5*math_hours) > 100#can't get more than 100
  ){
    final_y = NA
  } else {
    final_y = -y
  }
  return(final_y)
}





grade_max(c(6.4,4.5))


optim(c(4,3), grade_max, control=list(maxit=50000), method="Nelder-Mead")













 
# bounds = matrix(c(
#   0,11,
#   0,11), nc=2, byrow=TRUE)
# names(bounds) = c('lower','upper')
# n = nrow(bounds)
# ui = rbind(diag(n), -diag(n))
# ci = c(bounds[,1], bounds[,2])
# 
# ##Remove inifite values
# i = as.vector(is.finite(bounds))
# ui = ui[i, ]
# ci = ci[i]
# 
# ##Objective
# lang_calc_grades = function(x) -1*(40+x[1]*3.33 + 40+x[2]*5)
# 
# constrOptim(c(2,2), lang_calc_grades, method='Nelder-Mead', 
#             grad=NULL, ui=ui, ci=ci)
# 
# lang_calc_grades(c(2,2))





# grade_max = function(x) {
#   ##Enumerate constraints
#   max_budget = 100
#   time_avail = 11 #hrs
#   price_lang_lab = 5
#   price_math_tut = 15
#   current_french = current_calc = 40
#   min_passing_grade = 50
#   lang_avilable_time = 8
#   math_available_time = 7
# 
#   french_hours = ifelse(x[1]<=0, 0, x[1])
#   math_hours = ifelse(x[2]<=0, 0, x[2])
# 
#   ##Maximize objective function
#   french_grade_expected = (current_french+(3.33*french_hours))
#   calc_grade_expected = (current_calc+(5*math_hours))
#   y = french_grade_expected + calc_grade_expected
# 
#   ##Implement constraints
#   if(french_hours >= 0 & math_hours >= 0 & y <= 200 & y >=100 &
#      french_hours + math_hours <= time_avail & #time avail for student
#      french_hours <= lang_avilable_time & #lang lab constraint
#      math_hours <= math_available_time & #math tutor constraint
#      french_grade_expected >= min_passing_grade & #Passing grade lang
#      calc_grade_expected >= min_passing_grade & #Passing grade lang
#      price_lang_lab*french_hours + price_math_tut*math_hours <= max_budget & #budget constraint
#      current_french+(3.33*french_hours) <= 100 & #can't get more than 100
#      current_calc+(5*math_hours) <= 100#can't get more than 100
#   ){
#     y = NA
#   } else {
#     final_y = -y
#   }
#   return(final_y)
# }
