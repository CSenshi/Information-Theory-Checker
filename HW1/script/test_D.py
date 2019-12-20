import sys
ans_file = sys.argv[1]
my_file = sys.argv[2]

with open(ans_file, 'r') as af, open(my_file, 'r') as mf:
    ans_mean = float(af.readline())
    af.readline()
    ans_freq_arr = list(map(float, af.readline().split()))

    arr = [x for x in mf.read().splitlines()]

    sum = 0
    for i in range(len(arr)):
        sum += len(arr[i])*ans_freq_arr[i]
    sum = round(sum, 6)

    if sum != ans_mean:
        print("False")
        print("Answer Mean : {}".format(ans_mean))
        print("Your Mean :   {}".format(sum))
        exit()

    # check for prefix
    for c1 in arr:
        for c2 in arr:
            if c1 != c2 and c1.startswith(c2):
                print("False : {} is prefix of {}".format(c2, c1))

    print("True")
