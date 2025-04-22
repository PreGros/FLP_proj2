import subprocess
import os
import time

def loadData(loadedData, resultData):
    lines = loadedData.strip().split("\n")
    for line in lines:
        if (line != ""):
            spanTree = []
            elems = line.strip().split(" ")
            for elem in elems:
                spanTree.append(f'{elem[0]}{elem[2]}')
            resultData.append(spanTree) 

def checkIfIn(allSpanTreesResult, allSpantreesExpected, allSpanTreesNotFound):
    # for treeExpected in allSpantreesExpected:
    #     treeExpected.sort()

    for treeResult in allSpanTreesResult:
        treeResult = [''.join(sorted(elem)) for elem in treeResult]
        treeResult.sort()
        notFound = True
        for treeExpected in allSpantreesExpected:
            if (treeResult == treeExpected): 
                notFound = False
                allSpantreesExpected.remove(treeExpected)
                break
        if (notFound):
            allSpanTreesNotFound.append(treeResult)

def runTest(inputsPath, expectedPath, inputFileName):
    try:
        startTime = time.time()
        with open(f'{inputsPath}{inputFileName}', "r") as file:
            input_data = file.read()
            result = subprocess.run(
                ["../flp24-log"],
                input=input_data,
                text=True,
                capture_output=True
            )

        if (result.stderr):
            raise Exception(result.stderr)

        with open(f'{expectedPath}{inputFileName}') as expFile:
            expected_data = expFile.read()

        allSpanTreesExpected = []
        loadData(expected_data, allSpanTreesExpected)

        allSpanTreesResult = []
        loadData(result.stdout, allSpanTreesResult)

        allSpanTreesNotFound = []
        checkIfIn(allSpanTreesResult, allSpanTreesExpected, allSpanTreesNotFound)

        endTime = time.time()
        elapsedTime = endTime - startTime

        if (allSpanTreesNotFound == [] and allSpanTreesExpected == []):
            print(f'{inputFileName}: \033[32mSUCCESS!\033[0m | Time elapsed: {elapsedTime:.2f}')
        else:
            print(f'{inputFileName}: \033[31mFAILED!\033[0m')
            if (allSpanTreesNotFound != []):
                print("\033[31mUnknown generated spanning trees:\033[0m")
                print(allSpanTreesNotFound)
            if (allSpanTreesExpected != []):
                print("\033[31mMissing expected spannig trees:\033[0m")
                print (allSpanTreesExpected)

    except FileNotFoundError:
        print("File not found.")

def main():
    inputsPath = "inputs/"
    expectedPath = "expected/"

    inputFilesNames = os.listdir(inputsPath)

    for inputFileName in inputFilesNames:
        runTest(inputsPath, expectedPath, inputFileName)

if __name__ == "__main__":
    main()