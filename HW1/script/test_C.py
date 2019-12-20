import sys
import os

ans_file = sys.argv[1]
my_file = sys.argv[2]

with open(ans_file, 'r') as af, open(my_file, 'r') as mf:
    cv = float(af.readline())
    if cv > 1:
        if (os.stat(my_file).st_size == 0):
            print("True")
        else:
            print("False: Should be empty, Craft Value is {}".format(cv))
        exit()
    arr = list(map(int, af.readline().split()))

    code_arr = [x for x in mf.read().splitlines()]
    res_arr = [len(x) for x in code_arr]

    if arr != res_arr:
        print('False')
        print('Answer:      {} Length:{}'.format(arr, len(arr)))
        print('Your Result: {} Length:{}'.format(res_arr, len(res_arr)))
        exit()

    # check for prefix
    for c1 in code_arr:
        for c2 in code_arr:
            if c1 != c2 and c1.startswith(c2):
                print("False : {} is prefix of {}".format(c2, c1))
                exit()

    print('True')
