# Import datetime module
from datetime import datetime

current_time = datetime.now()

print("carana9896's Speadsheet Automation Menu")
while True:
    choice = input("Choose a number from the following options\n1 Input Data\n2 View Current Date\n3 Generate Report\n")
    
    if choice == "1":
        print("you selected 1 at", current_time, "\n")
    elif choice == "2":
        print("you selected 2 at", current_time, "\n")
    elif choice == "3":
        print("you selected 3 at", current_time, "\n")
    elif choice == "4":
        print("you selected 4 at", current_time, "\n")
    else:
        print("Error: invalid choice selected\n")
