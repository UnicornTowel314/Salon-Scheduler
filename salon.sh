#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~ Welcome to The Fish Bowl Salon ~~~\n"

MAIN_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # display services
  echo -e"~~ Our Services ~~\n"

  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, service FROM services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done

  echo -e "\nWhat can we schedule for you today?"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SCHEDULE_APPOINTMENT "Cut" ;;
    2) SCHEDULE_APPOINTMENT "Color" ;;
    3) SCHEDULE_APPOINTMENT "Cut and Color" ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

SCHEDULE_APPOINTMENT () {
  SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service = '$1'")
  # get customer phone number
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_NUMBER

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_NUMBER'")
  # if it doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get customer name
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME
    # insert into customer table
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_NUMBER', '$CUSTOMER_NAME')")
  fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # get desired appointment time
  echo -e "\nWhen would you like to come in for your appointment?"
  read SERVICE_TIME

  # insert into appointments
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  # display confirmation message

  echo -e "\nI have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU