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
        machineCode = "0" + '{0:07b}'.format(int(code[2][1:])) + GPR[code[1]] + opCodes["LAS"] 
    elif code[0] == "SKR":
        machineCode = "0" + '{0:07b}'.format(int(code[2][1:])) + GPR[code[1]] + opCodes["SKR"]
    elif code[0] == "STO":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["STO"]
    elif code[0] == "MIN":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["MIN"]
    elif code[0] == "LIG":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["LIG"]
    elif code[0] == "AND":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["AND"]
    elif code[0] == "ORR":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["ORR"]
    elif code[0] == "ADD":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["ADD"]
    elif code[0] == "SUB":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["SUB"]
    elif code[0] == "DIV":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["DIV"]
    elif code[0] == "MUL":
        machineCode = "0" + GPR[code[3]] + "0" + GPR[code[2]] + GPR[code[1]] + opCodes["MUL"]
    elif code[0] == "HOP":
        machineCode =  "0" + format(code[1][1:], 'b') + "000" + opCodes["HOP"]
    elif code[0] == "UAL":
        machineCode = "00000000" + GPR[code[1]] + opCodes["UAL"]
    elif code[0] == "UAS":
        machineCode = "00000000" + GPR[code[1]] + opCodes["UAS"]
    elif code[0] == "VIS":
        machineCode = "00000000" + GPR[code[1]] + opCodes["VIS"]
    elif code[0] == "HOPC":
        machineCode = "0" + '{0:07b}'.format(int(code[1][1:])) + "000" + opCodes["HOPC"]
    elif code [0] == "HOPUC":
        machineCode = "0" + '{0:07b}'.format(int(code[1][1:])) + "000" + opCodes["HOPUC"]

    machineCodeFile.write(machineCode)
    machineCodeFile.write("\n")
    machineCodeFile.close()

assemblyFile.close()


