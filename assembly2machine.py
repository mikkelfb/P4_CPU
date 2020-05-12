opCodes = { "NOP": "00000",
            "LAS": "00001",
            "SKR": "00010",
            "STO": "00011",
            "MIN": "00100",
            "LIG": "00101",
            "AND": "00110",
            "ORR": "00111",
            "ADD": "01000",
            "SUB": "01001",
            "DIV": "01010",
            "MUL": "01011",
            "HOP": "01100",
            "UAL": "01101",
            "UAS": "01110",
            "VIS": "01111",
            "SDS": "10000",
            "HOPC": "10001",
            "HOPUC": "10010"}

GPR = { "R0": "000",
        "R1": "001",
        "R2": "010",
        "R3": "011",
        "R4": "100",
        "R5": "101",
        "R6": "110",
        "R7": "111"}

assemblyFile = open("assembly.txt", 'r')
machineCodeFile = open("program.bin", 'w+')
machineCodeFile.close()

Lines = assemblyFile.readlines()

machineCode = ""

for line in Lines:
    machineCodeFile = open("program.bin", "a")
    code = line.split()
    if code[0] == "NOP":
        machineCode = "0000000000000000"
    elif code[0] == "LAS":
        machineCode = opCodes["LAS"] + GPR[code[1]] + '{0:07b}'.format(int(code[2][1:])) + "0"
    elif code[0] == "SKR":
        machineCode = opCodes["SKR"] + GPR[code[1]] + '{0:07b}'.format(int(code[2][1:])) + "0"
    elif code[0] == "STO":
        machineCode = opCodes["STO"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "MIN":
        machineCode = opCodes["MIN"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "LIG":
        machineCode = opCodes["LIG"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "AND":
        machineCode = opCodes["AND"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "ORR":
        machineCode = opCodes["ORR"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "ADD":
        machineCode = opCodes["ADD"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "SUB":
        machineCode = opCodes["SUB"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "DIV":
        machineCode = opCodes["DIV"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "MUL":
        machineCode = opCodes["MUL"] + GPR[code[1]] + GPR[code[2]] + "0" + GPR[code[3]] + "0"
    elif code[0] == "HOP":
        machineCode = opCodes["HOP"] + "000" + format(code[1][1:], 'b') + "0"
    elif code[0] == "UAL":
        machineCode = opCodes["UAL"] + GPR[code[1]] + "00000000"
    elif code[0] == "UAS":
        machineCode = opCodes["UAS"] + GPR[code[1]] + "00000000"
    elif code[0] == "VIS":
        machineCode = opCodes["VIS"] + GPR[code[1]] + "00000000"
    elif code[0] == "HOPC":
        machineCode = opCodes["HOPC"] + "000" + '{0:07b}'.format(int(code[1][1:])) + "0"
    elif code [0] == "HOPUC":
        machineCode = opCodes["HOPUC"] + "000" + '{0:07b}'.format(int(code[1][1:])) + "0"

    print (machineCode[::-1])
    machineCodeFile.write(machineCode[::-1])
    machineCodeFile.write("\n")
    machineCodeFile.close()

assemblyFile.close()


