## Script to calculate tutorial attendance
## Andy Wills
## GPL 3.0

library(tidyverse)                      ## Load packages
tut <- read_csv("attendance.csv")  ## Load data

## Extract list of student name <-> studentID links
id.name <- tut %>% select(PsyGateID, ProgID, ForeName, Surname)

## Convert data to long format
tut <- tut %>% 
  gather(key = "tutorial", value = "attend", Tutorial01:Tutorial10)

## Make tutorial ID numeric
tut$tutorial <- as.numeric(factor(tut$tutorial))

## Eliminate non-real tutorials
tut <- tut %>% filter(tutorial < 8 | (tutorial >= 8 & ProgID < 200))

## Select just the columns we need
tut <- tut %>% select(PsyGateID, TutorSName, tutorial, attend)

## Look at tutor failures to enter attendance
tutorfails <- tut %>% 
  group_by(TutorSName) %>% 
  filter(attend == "NULL") %>% 
  summarise(N = n()) %>%
  filter(N > 0)

## Code NULL attendance (which is attendance not recorded by tutor) as NA
tut$attend[tut$attend == "NULL"] <- NA

## Classify each attendance as present, absent, or missing data (NA)
tut <- tut %>% 
  mutate(att = recode(attend, "1" = 1, "2" = 0, "8" = 1))

## Attendance by student
attstud <- tut %>% 
  group_by(PsyGateID) %>% 
  summarise(pc = round(mean(att, na.rm = TRUE) * 100))

## Code pass/fail
attstud <- attstud %>% mutate(pf = if_else(pc >= 80, TRUE, FALSE))

## Pass/fail results
pass.fail <- merge(id.name, attstud) %>% arrange(ProgID, Surname, ForeName)
rm(attstud)

## Analyse by Module
pc.module <- pass.fail %>% group_by(ProgID) %>% summarize(meanatt = mean(pc, na.rm = TRUE))

