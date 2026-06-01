from datetime import datetime
current_time = datetime.now()

#Take one numberical value to convert 
def convertData(value, spreadsheet_type):
    if spreadsheet_type == "temperature":
        return (value - 32)* 5/9
    elif spreadsheet_type == "weight":
        return (value / 2.205)
    elif spreadsheet_type == "rain":
        return (value * 2.54)
    else:
        return none
    
#temp function
def getTempInput():
    num = int(input("How many entries are you inputting?"))

    for i in range(num):
        print("\nEnter a date:\n")
        date = input()
        value = float(input("Enter the highest temp for the inputted date:\n"))
        #call converdata function
        converted = convertData(value,"temperature")

        print(f"The following was saved at {datetime.now()}: ")
        print(f"{date},{value},{converted}")

#weight function
def getWeightInput():
    num = int(input("How many entries are you inputting?"))

    for i in range(num):
        print("\nEnter a date:\n")
        date = input()
        value = float(input("Enter the weight in pounds for the inputted date:\n"))
        #call converdata function
        converted = convertData(value,"weight")

        print(f"The following was saved at {datetime.now()}: ")
        print(f"{date},{value},{converted}")

#rain function
def getRainInput():
    num = int(input("How many entries are you inputting?"))

    for i in range(num):
        print("\nEnter a date:\n")
        date = input()
        value = float(input("Enter the rain amount in inches for the inputted date:\n"))
        #call converdata function
        converted = convertData(value,"rain")

        print(f"The following was saved at {datetime.now()}: ")
        print(f"{date},{value},{converted}")
                      
def main():
    print("carana9896's Speadsheet Automation Menu")
    print("Choose a number from the following options\n1 Input Data\n2 View Current Date\n3 Generate Report\n")

    choice = input()

    if choice == "1":
        print("You selected 1 at", datetime.now())
#Ask which spreadsheet type this run is for
        print("\nSelect spreadsheet type: ")
        print("1 Temperature (F to C)")
        print("2 Weight (lbs to kg)")
        print("3 Rainfall (inches to cm)")
        stype = input("Enter choice: ")

        if stype == "1":
            getTempInput()
        elif stype == "2":
            getWeightInput()
        elif stype == "3":
            getRainInput()
        else:
            print("Invalid spreadsheet type selected")
    else:
       print("Error: The chosen functionality is not implemented yet")


main()
        
