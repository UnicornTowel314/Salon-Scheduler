#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ Welcome to The Fish Bowl Salon ~~\n"

MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "~~ Our Services ~~\n"
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done

  echo -e "\nWhat can we schedule for you today?"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SCHEDULE_APPOINTMENT "cut" ;;
    2) SCHEDULE_APPOINTMENT "color" ;;
    3) SCHEDULE_APPOINTMENT "cut and color" ;;
    4) SCHEDULE_APPOINTMENT "perm" ;;
    5) SCHEDULE_APPOINTMENT "style" ;;
    *) MENU "Service not found. Please make another selection." ;;
  esac
}

SCHEDULE_APPOINTMENT () {
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  echo -e "\nWhen would you like to come in for your appointment, $CUSTOMER_NAME?"
  read SERVICE_TIME

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $(echo $SERVICE | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
}

MENU