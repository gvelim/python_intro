with open("input.txt", "r") as f:
    for line in f.readlines():
        print(line + '\n') # print each line


with open("input1.txt", "r") as f1:
    # print only first line of f1
    print(f1.readline())

