## Script to calculate tutorial attendance
## Andy Wills (words) and Jon May (pictures)
## GPL 3.0

## Load packages
library(tidyverse)

## Load data
tut <- read_csv("attendance.csv")  

## Preprocess data to more useful format

### Extract list of student names and IDs
id.name <- tut %>% select(PsyGateID, ProgID, ForeName, Surname)

### Convert data to long format
tut <- tut %>% 
  gather(key = "tutorial", value = "attend", Tutorial01:Tutorial10)

### Make tutorial ID numeric
tut$tutorial <- as.numeric(factor(tut$tutorial))

### Eliminate non-real tutorials
tut <- tut %>% filter(tutorial < 8 | (tutorial >= 8 & ProgID < 200))

### Select just the columns we need
tut <- tut %>% select(PsyGateID, TutorSName, tutorial, attend)

## Look at tutor failures to record attendance
tutorfails <- tut %>% 
  group_by(TutorSName) %>% 
  filter(attend == "NULL") %>% 
  summarise(N = n()) 

## Attendance by student

### Code NULL attendance (which is attendance not recorded by tutor) as NA
tut$attend[tut$attend == "NULL"] <- NA

### Classify each attendance as present, absent, or missing data (NA)
### (in loaded data, 1 = present, 2 = absent, 8 = excused)
tut <- tut %>% 
  mutate(att = recode(attend, "1" = 1, "2" = 0, "8" = 1, "NULL" = 0))

### Calculate attendance percentage
attstud <- tut %>% 
  group_by(PsyGateID) %>% 
  summarise(attend.pc = round(mean(att, na.rm = TRUE) * 100))

### Code student pass/fail
attstud <- attstud %>% mutate(pass = if_else(attend.pc >= 80, TRUE, FALSE))

## Pass/fail results
pass.sum <- merge(id.name, attstud) %>% arrange(ProgID, Surname, ForeName)
rm(attstud)

## Analyse by Module 

### Mean percent attendance
pc.module <- pass.sum %>% group_by(ProgID) %>% 
  summarize(meanatt = mean(attend.pc, na.rm = TRUE))

### Percentage passing
pc.module.pass <- pass.sum %>% group_by(ProgID) %>% 
  summarize(meanatt = round(mean(pass, na.rm = TRUE) * 100))

## Analyse by Stage

### Add variable for Stage, using ModuleID
pass.sum <- pass.sum %>% 
  mutate(Stage = case_when(
    ProgID <= 199 ~ 1,
    ProgID <= 299 ~ 2,
    ProgID <= 499 ~ 4))

### Mean percent attendance
pc.stage <- pass.sum %>% group_by(Stage) %>% 
  summarize(meanatt = mean(attend.pc, na.rm = TRUE))

### Percentage passing
pc.stage.pass <- pass.sum %>% group_by(Stage) %>% 
  summarize(meanatt = round(mean(pass, na.rm = TRUE) * 100))

### Check Excel analysis against R analysis
excel <- read_csv("excelfail.csv")
xl.pass <- excel %>% select(PsyGateID, xlpass)
compare <- merge(pass.sum, xl.pass)

### Every decision the same
compare %>% filter(xlpass != pass)

### create a visualisation of attendance for each tutor by tutorial

### count up everyone's tuteees and compute attendance percentage for each tutorial
tut.att<-tut %>%
  group_by(TutorSName, tutorial) %>%
  summarise(attend.N = n()/50, 
            attend.pc = round(mean(att, na.rm = TRUE) * 100) ) 

### plot with tutors on y, tutorial on x, attendance as red to green, size as N
ggplot(tut.att, 
          aes(x=tutorial, y=reorder(TutorSName, desc(TutorSName)))) +
          geom_point(aes(color = attend.pc, size=attend.N)) +
          scale_color_gradient(low="red", high="green", name="Attendance") +
          ylab("Tutor") +
          guides(size="none")



