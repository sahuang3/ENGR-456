letters = ["A","B","C","D","E","F"]
table = []

for x in range(256): table.append(0)
with open("ac_lum.txt", "r") as f:
    lines = f.readlines()
    for line in lines:
        tokens = line.split()
        index_tokens = tokens[0].split('/')
        if index_tokens[0] in letters and index_tokens[1] in letters:
            index = (int(ord(index_tokens[0]) - ord('A') + 10) << 4) + int(ord(index_tokens[1]) - ord('A') + 10)
        elif index_tokens[0] in letters:
            index = (int(ord(index_tokens[0]) - ord('A') + 10) << 4) + int(index_tokens[1])
        elif index_tokens[1] in letters:
            index = (int(index_tokens[0]) << 4) + int(ord(index_tokens[1]) - ord('A') + 10)
        else:
            index = (int(index_tokens[0]) << 4) + int(index_tokens[1])
            
        table[index] = int(tokens[2],2)

with open("table.txt", "w") as f:
    for x in table[:-1]:
        f.write("{},".format(x))
    f.write("{}".format(table[-1]))
