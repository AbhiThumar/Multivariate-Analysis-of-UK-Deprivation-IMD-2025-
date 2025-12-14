import numpy as np


####################### PART-1 #######################
P = np.zeros((9,9))

def final_destination(j_dash):
    if j_dash == 1:
        return 6
    if j_dash == 2:
        return 4
    if j_dash == 5:
        return 0
    if j_dash == 7:
        return 3
    return j_dash

for i in range(8):
    # Heads (Moves 1 step ahead)
    j1_dash = i + 1
    if j1_dash <=8:
        j1 = final_destination(j1_dash)
        P[i, j1] += 0.5
    
    # Tails (Moves 2 step ahead)
    j2_dash = i + 2
    if j2_dash <= 8:
        j2 = final_destination(j2_dash)
        P[i,j2] += 0.5
    else:
        P[i, j2] += 0.5 #for 7 --> 9 is also game complete
        
        
P[8,8] = 1
P = P.T
print("transition matrix\n",P)




####################### PART-2 #######################

N = P[:8, :8]

I = np.identity(8)
M = np.linalg.inv(I - N)


print("\n Matrix M = \n",M)

u_col_sum = np.sum(M, axis=0)


print("\nExpected number of coin flips required:")
for i in range(8):
    print(f"{i} ------> {u_col_sum[i]:.4f}")

