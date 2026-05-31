from datetime import datetime

#function to determine if the number is even or odd
def EvenOdd (num: int) -> bool:
    return num% 2 == 0

def main():
    print("carana9896", datetime.now())

    numbers = [3,14,23,30]

    for num in numbers:
        if EvenOdd(num):
            print(f"{num} is even")
        else:
            print(f"{num} is odd")

main()
