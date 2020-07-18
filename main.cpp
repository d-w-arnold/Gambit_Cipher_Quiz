#include <iostream>
#include <string>

using namespace std;

/**
 * Solution to Gambit Quiz, in order to apply for a job with Gambit Research.
 *
 * https://gambitresearch.com/quiz/
 *
 * In the source code found at the above URL, nested within 'div.entry-content',
 * the following JavaScript function can be found:
 *
 * <script type="text/javascript">
 *   // You're on the right path!
 *   function scramble(message, a, b, c) {
 *     return message.split('').map((chr, i) => {
 *       const code = chr.charCodeAt(0)
 *       switch(i % 3) {
 *         case 0: return (code + a) % 256
 *         case 1: return (code + b) % 256
 *         case 2: return (code + c) % 256
 *       }
 *     }).join(' ')
 *   }
 * </script>
 *
 * The cipher text displayed at the above URL is encrypted used a Vigenère (symmetric) cipher, where the key is of
 * length 3 (made up of the variables: a, b and c), and each variable represents an ASCII value.
 *
 * The main function is a brute-force approach to working out the ASCII values used in place
 * of variables: a, b and c. Where we each variable can be in the range of [0,255].
 *
 * @return return value
 */
int main() {

    // Cipher text from: https://gambitresearch.com/quiz/
    int cipher[] = {4, 50, 180, 40, 60, 116, 220, 16, 183, 42, 52, 186, 29, 65, 189, 40, 46, 188, 37, 60, 182, 47, 237,
                    174, 43, 63, 104, 47, 60, 180, 50, 54, 182, 35, 237, 188, 36, 50, 104, 3, 46, 181, 30, 54, 188, 220,
                    48, 176, 29, 57, 180, 33, 59, 175, 33, 251, 104, 12, 57, 173, 29, 64, 173, 220, 64, 173, 42, 49,
                    104, 53, 60, 189, 46, 237, 187, 43, 57, 189, 48, 54, 183, 42, 237, 169, 42, 49, 104, 255, 35, 104,
                    48, 60, 104, 37, 48, 169, 42, 48, 183, 32, 50, 136, 35, 46, 181, 30, 54, 188, 46, 50, 187, 33, 46,
                    186, 31, 53, 118, 31, 60, 181, 220, 62, 189, 43, 65, 177, 42, 52, 104, 46, 50, 174, 33, 63, 173, 42,
                    48, 173, 246, 237, 173, 34, 1, 122, 243, 255, 121, 244, 47, 174};
    int cipherSize = sizeof(cipher) / sizeof(cipher[0]);
    string wordToMatch = "Gambit";

    // Try all possible combinations of ASCII values for the 3 letter key (abc).
    for (int a = 0; a <= 255; a++) {
        for (int b = 0; b <= 255; b++) {
            for (int c = 0; c <= 255; c++) {
                cout << "a = " << a << ", b = " << b << ", c = " << c << endl;
                char message[cipherSize];
                for (int i = 0; i < cipherSize; i++) {
                    message[i] = (char) cipher[i];
                    switch (i % 3) {
                        case 0:
                            message[i] -= a;
                            break;
                        case 1:
                            message[i] -= b;
                            break;
                        case 2:
                            message[i] -= c;
                            break;
                    }
                }
                string str = message;
                // The correct values for a, b and c will contain the wordToMatch in the decrypted plain text.
                if (str.find(wordToMatch) != string::npos) {
                    cout << endl << "Decrypted Message: " << str << endl;
                    cout << "Key: a = " << a << ", b = " << b << ", c = " << c << endl;
                    return 0;
                }
            }
        }
    }
    cout << endl << "Could not find a decryption containing: " << wordToMatch << endl;

    return 0;
}
