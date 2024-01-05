#minimum required version python3.7
import os
import subprocess

inputArray = [
          ["test0_0.in"]
        , ["test1_0.in", "test1_1.in"]
        , ["test0_0.in"]
]
outputArray = [
          ["0 0 0 0 0 0 0 0 0 0 0 0 "],
          ["0x70E1F26F6E63", "parola"],
          ["0 0 0 0 0 0 0 0 0 0 0 0 "]
]
points = [
          [50],
          [15, 10],
          [25]
]


for file in os.listdir('.'):
        if os.path.isfile(file) and (file[-2:] == ".s" or file[-2:] == ".S"):
                        print(file)
                        subprocess.call(["gcc", "-m32", file, "-o", "cerinta" + file[-3]], )

executables = ["./cerinta0", "./cerinta1", "./cerinta2"]

estimatedGrade = 0

for taskIndex in range(len(executables)):
    findResult = subprocess.call(["find", executables[taskIndex]], stdout=subprocess.DEVNULL,
    stderr=subprocess.STDOUT)
    if findResult:
        print("Executable %s not found!" % executables[taskIndex])
        continue

    print("Task " + str(taskIndex) + ":")

    taskInputArray = inputArray[taskIndex]
    taskOutputArray = outputArray[taskIndex]
    taskPoints = points[taskIndex]

    for i in range(len(taskInputArray)):
        try:
            inputFile = open(taskInputArray[i])
            captureOutput = True
            if taskIndex == 2:
               subprocess.run(["cp", taskInputArray[i], "in.txt"])
               captureOutput = False
            result = subprocess.run([executables[taskIndex]], shell = True, timeout=10, stdin=inputFile, text=True, capture_output=captureOutput)
            if taskIndex != 2:
                output = result.stdout
                output = output.replace("\n", "")
                output = output.replace("\0", "")
            else:
                result = subprocess.run(["cat", "out.txt"], capture_output = True, text = True)
                output = result.stdout
                output = output.replace("\n", "")
                output = output.replace("\0", "")
                subprocess.run(["rm", "in.txt", "out.txt"])
            if output == taskOutputArray[i]:
                estimatedGrade += taskPoints[i]
                print("\tTest " + str(i) + ": OK (" + str(taskPoints[i]) + ")")
            else:
                print("\tTest " + str(i) + " failed (0p)")
                print("\t   Input: ")
                with open(taskInputArray[i], "r") as f:
                    lines = f.readlines()
                    for line in lines:
                        print(line[:-1])
                print("\t   Your output:", end =" ")
                print(output)

                arr = bytes(output, 'utf-8')
                print("\t   Your output in bytes:", end =" ")
                # actual bytes in the the string
                for byte in arr:
                    print(byte, end=' ')
                print("\n")


                print("\t   Expected output:", end = " ")
                print(taskOutputArray[i])

                arr = bytes(taskOutputArray[i], 'utf-8')
                print("\t   Expected output in bytes:", end =" ")
                # actual bytes in the the string
                for byte in arr:
                        print(byte, end=' ')
                print("\n")
        except:
           print("\tTest " + str(i) + ": exception! (0p)")
        print("\n")

print("Estimated grade %dp / 100" % (estimatedGrade))