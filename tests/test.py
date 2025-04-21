import subprocess

def checkIfIn(allSpanTreesResult, allSpantreesExpected, allSpanTreesNotFound):
    for treeExpected in allSpantreesExpected:
        treeExpected.sort()

    for treeResult in allSpanTreesResult:
        treeResult.sort()
        notFound = True
        for treeExpected in allSpantreesExpected:
            if (treeResult == treeExpected): 
                notFound = False
                allSpantreesExpected.remove(treeExpected)
                break
        if (notFound):
            allSpanTreesNotFound.append(treeResult)

def main():
    try:
        with open("inputs/input_testr-01", "r") as file:
            input_data = file.read()
            result = subprocess.run(
                ["../flp24-log"],
                input=input_data,
                text=True,
                capture_output=True
            )

        with open("expected/exp-test-01") as expFile:
            expected_data = expFile.read()

        allSpanTreesExpected = []
        lines = expected_data.strip().split("\n")
        for line in lines:
            if (line != ""):
                spanTree = []
                elems = line.strip().split(" ")
                for elem in elems:
                    spanTree.append(f'{elem[0]}{elem[2]}')
                allSpanTreesExpected.append(spanTree) 

        allSpanTreesResult = []
        lines = result.stdout.strip().split("\n")
        for line in lines:
            if (line != ""):
                spanTree = []
                elems = line.strip().split(" ")
                for elem in elems:
                    spanTree.append(f'{elem[0]}{elem[2]}')
                allSpanTreesResult.append(spanTree)

        allSpanTreesNotFound = []
        checkIfIn(allSpanTreesResult, allSpanTreesExpected, allSpanTreesNotFound)
        

        if (result.stderr):
            print("Program errors:")
            print(result.stderr)
        else:
            if (allSpanTreesNotFound != []):
                print("\033[31mUnknown generated spanning trees:\033[0m ")
                print(allSpanTreesNotFound)
            if (allSpanTreesExpected != []):
                print("\033[31mMissing expected spannig trees:\033[0m ")
                print (allSpanTreesExpected)
            
        if (allSpanTreesNotFound == [] and allSpanTreesExpected == []):
            print("\033[32mTest successed!\033[0m")

    except FileNotFoundError:
        print("File not found.")

if __name__ == "__main__":
    main()