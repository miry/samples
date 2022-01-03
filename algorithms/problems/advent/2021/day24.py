# Not my solution.
# Imported from https://www.reddit.com/r/adventofcode/comments/rnejv5/comment/hpypzhp/?utm_source=share&utm_medium=web2x&context=3
# Code: https://pastebin.com/Q68bWTAV
file = "input/day24.txt"

digit_process = []

with open(file, 'r') as f:
    process = []
    for line in f:
        line = line.strip()

        if line.startswith("inp"):
            if process:
                digit_process.append(process)
            process = []

        process.append(line.split())
    digit_process.append(process)
N = len(digit_process)

class Number:
    def __init__(self, digit):
        self.digit = digit

    def __repr__(self):
        return f"Digit {self.digit}"

variables = {"x": [], "y": [], "z": [], "w": []}
constraints = []
for i in range(14):
    # Process each block and see what are the constraints
    block = digit_process[i]
    fulfilled_constraint = True
    for command in digit_process[i]:
        if len(command) == 0:
          continue
        print(command)
        instr = command[0]
        v1 = command[1]

        if instr == "inp":
            variables["w"] = [Number(i)]
            continue

        v2 = command[2]
        if v2 in variables:
            val2 = variables[v2]
        else:
            val2 = int(v2)

        if instr == "mul":
            if val2 == 0:
                variables[v1] = []
        elif instr == "add":
            if v1 == "x":
                if v2 == "z":
                    # We append the contents of z to x
                    variables[v1] += [_[:] for _ in variables[v2]]
                else:
                    variables[v1].append(val2)
            elif v1 == "y":
                if val2 == 25:
                    continue
                else:
                    if isinstance(val2, list):
                        variables[v1] += val2[:]
                    else:
                        variables[v1].append(val2)
            elif v1 == "z":
                if v2 == "y":
                    if fulfilled_constraint:
                        # Basically do nothing
                        pass
                    else:
                        variables[v1].append(variables[v2][:])
        elif instr == "mod":
            if val2 == 26:
                if variables[v1]:
                    variables[v1] = variables[v1][-1]
        elif instr == "div":
            if val2 == 1:
                continue
            elif val2 == 26:
                if v1 == "z":
                    variables[v1].pop()
        elif instr == "eql":
            if v1 == "x":
                if v2 == "w":
                    if variables[v1]:
                        _sum = 0
                        for el in variables[v1]:
                            if isinstance(el, list):
                                continue
                            if isinstance(el, Number):
                                continue
                            _sum += el

                        if _sum > 9:
                            fulfilled_constraint = False
                        if fulfilled_constraint:
                            # If we have a constraint
                            constraints.append([variables[v1][:], Number(i)])
                        variables[v1] = []
                elif val2 == 0:
                    # We do nothing because in the previous block we assume if
                    # we have a fulfilled constraint or not
                    #variables[v1] = []
                    pass



def get_serial_number(constraints, part=1):
    # For part one find the maximum possible digit
    serial_number = ["" for i in range(14)]

    for constraint in constraints:
        # Figure out which indexes to process
        # LHS
        lhs_index = None
        lhs_constraint = 0
        for content in constraint[0]:
            if isinstance(content, Number):
                lhs_index = content.digit
            else:
                lhs_constraint += content

        # RHS
        rhs_index = constraint[1].digit
        if part==1:
            # Get maximum number
            if lhs_constraint > 0:
                serial_number[lhs_index] = 9 - lhs_constraint
                serial_number[rhs_index] = 9
            else:
                serial_number[lhs_index] = 9
                serial_number[rhs_index] = 9 + lhs_constraint
        else:
            if lhs_constraint > 0:
                serial_number[lhs_index] = 1
                serial_number[rhs_index] = 1 + lhs_constraint
            else:
                serial_number[lhs_index] = abs(lhs_constraint) + 1
                serial_number[rhs_index] = 1
    return ''.join([str(_) for _ in serial_number])
print("Part 1: ", get_serial_number(constraints, 1))
print("Part 2: ", get_serial_number(constraints, 2))



