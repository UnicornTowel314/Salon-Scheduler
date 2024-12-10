#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~ Welcome to The Fish Bowl Salon ~~~\n"

MAIN_MENU () {
  # display services
  echo -e"~~ Our Services ~~\n"
  echo -e "1) Cut\n2)Color\n3)Cut and Color"
  echo -e "\nWhat can we schedule for you today?"
  read MENU_SELECTION
  # ask what service the customer wants to schedule
  # if service doesn't exist
    # display services again
  # get customer phone number
  # if it doesn't exist
    # get customer name
    # insert into customer table
  # get desired appointment time
  # insert into appointments
  # display confirmation message
}