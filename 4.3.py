from datetime import datetime

# convertData(value, spreadsheet_type):
# Takes a numerical value and converts it based on the spreadsheet type.
def convertData(value, spreadsheet_type):
    if spreadsheet_type == "temperature":
        return (value - 32) * 5/9
    elif spreadsheet_type == "weight":
        return value / 2.205
    elif spreadsheet_type == "rain":
        return value * 2.54
    else:
        return None


# insertData(path, data):
# Appends a comma-separated string to a CSV file using try/except.
def insertData(path, data):
    try:
        with open(path, "a") as file:
            file.write(data + "\n")
    except Exception as e:
        print("Error writing to file:", e)


# viewData(path):
# Reads and displays the contents of the CSV file using minimal permissions.
def viewData(path):
    try:
        print(f"The file {path}")
        with open(path, "r") as file:
            print(file.read())
    except Exception as e:
        print("Error reading file:", e)


# getTempInput():
# Collects temperature entries, converts them, and saves them to ZooData.csv.
def getTempInput():
    path = "ZooData.csv"
    num = int(input("How many entries are you inputting? "))

    for i in range(num):
        try:
            print("\nEnter a date:")
            date = input()
            value = float(input("Enter the highest temp for the inputted date:\n"))

            converted = convertData(value, "temperature")
            data = f"{date},{value},{converted}"

            insertData(path, data)

            print(f"The following data was saved at {datetime.now()}: {data}")

        except Exception as e:
            print("Error processing temperature input:", e)


# getWeightInput():
# Collects weight entries, converts them, and saves them to ZooData.csv.
def getWeightInput():
    path = "ZooData.csv"
    num = int(input("How many entries are you inputting? "))

    for i in range(num):
        try:
            print("\nEnter a date:")
            date = input()
            value = float(input("Enter the weight in pounds for the inputted date:\n"))

            converted = convertData(value, "weight")
            data = f"{date},{value},{converted}"

            insertData(path, data)

            print(f"The following data was saved at {datetime.now()}: {data}")

        except Exception as e:
            print("Error processing weight input:", e)


# getRainInput():
# Collects rainfall entries, converts them, and saves them to ZooData.csv.
def getRainInput():
    path = "ZooData.csv"
    num = int(input("How many entries are you inputting? "))

    for i in range(num):
        try:
            print("\nEnter a date:")
            date = input()
            value = float(input("Enter the rain amount in inches for the inputted date:\n"))

            converted = convertData(value, "rain")
            data = f"{date},{value},{converted}"

            insertData(path, data)

            print(f"The following data was saved at {datetime.now()}: {data}")

        except Exception as e:
            print("Error processing rain input:", e)


# main():
# Displays menu and controls program flow.
def main():
    print("carana9896's Spreadsheet Automation Menu")
    print("Choose a number from the following options")
    print("1 Input Data")
    print("2 View Current Data")
    print("3 Generate Report\n")

    choice = input()

    if choice == "1":
        print("You selected 1 at", datetime.now())
        print("\nSelect spreadsheet type:")
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
            print("Invalid spreadsheet type selected.")

    elif choice == "2":
        viewData("ZooData.csv")

    else:
        print("Error: The chosen functionality is not implemented yet")


main()

