import 'dart:convert';

void main(List<String> arguments) {
  final original = 'rmJ008k4ONy13+MmIA==';
  // Replace all zeros with O because that's how the program works
  final workable = original.replaceAll('0', 'O');
  printAllCombinations(workable);
}

void printAllCombinations(String inputString) {
  // Find the indices of all "O" characters in the input string
  List<int> oIndices = [];
  for (int i = 0; i < inputString.length; i++) {
    if (inputString[i] == 'O') {
      oIndices.add(i);
    }
  }

  // Generate all possible combinations of 0s and 1s for the "O" characters
  for (int i = 0; i < (1 << oIndices.length); i++) {
    // Create a new string to hold the output
    String outputString = '';
    // Keep track of which "O" character we are currently processing
    int oIndex = 0;
    // Loop through each character in the input string
    for (int j = 0; j < inputString.length; j++) {
      if (oIndex < oIndices.length && j == oIndices[oIndex]) {
        // If this is an "O" character, replace it with a 0 or * depending on the current bit value in the bit mask
        outputString += ((i & (1 << oIndex)) > 0) ? '*' : '0';
        // Move to the next "O" character
        oIndex++;
      } else {
        // If this is not an "O" character, keep the original character
        outputString += inputString[j];
      }
    }

    // Print the generated string to the console
    outputString = outputString.replaceAll('*', 'O');
    print('---');
    print(outputString);
    print(utf8.decode(base64Decode(outputString), allowMalformed: true));
  }
}
