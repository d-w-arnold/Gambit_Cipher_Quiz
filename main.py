from string import digits, ascii_letters, punctuation

valid_characters = digits + ascii_letters + punctuation + " "
cipher = [4, 50, 180, 40, 60, 116, 220, 16, 183, 42, 52, 186, 29, 65, 189, 40, 46, 188, 37, 60, 182, 47, 237, 174,
          43, 63, 104, 47, 60, 180, 50, 54, 182, 35, 237, 188, 36, 50, 104, 3, 46, 181, 30, 54, 188, 220, 48, 176,
          29, 57, 180, 33, 59, 175, 33, 251, 104, 12, 57, 173, 29, 64, 173, 220, 64, 173, 42, 49, 104, 53, 60, 189,
          46, 237, 187, 43, 57, 189, 48, 54, 183, 42, 237, 169, 42, 49, 104, 255, 35, 104, 48, 60, 104, 37, 48, 169,
          42, 48, 183, 32, 50, 136, 35, 46, 181, 30, 54, 188, 46, 50, 187, 33, 46, 186, 31, 53, 118, 31, 60, 181,
          220, 62, 189, 43, 65, 177, 42, 52, 104, 46, 50, 174, 33, 63, 173, 42, 48, 173, 246, 237, 173, 34, 1, 122,
          243, 255, 121, 244, 47, 174]
cipher_size = len(cipher)
word_to_match = "Gambit"


# Solution to Gambit Quiz, in order to apply for a job with Gambit Research.
#
# https://gambitresearch.com/quiz/
#
# In the source code found at the above URL, nested within 'div.entry-content',
# the following JavaScript function can be found:
#
# <script type="text/javascript">
#    // You're on the right path!
#    function scramble(message, a, b, c) {
#      return message.split('').map((chr, i) => {
#        const code = chr.charCodeAt(0)
#        switch(i % 3) {
#          case 0: return (code + a) % 256
#          case 1: return (code + b) % 256
#          case 2: return (code + c) % 256
#        }
#      }).join(' ')
#    }
# </script>
#
# The cipher text displayed at the above URL is encrypted used a Vigenère (symmetric) cipher, where the key is of
# length 3 (made up of the variables: a, b and c), and each variable represents an ASCII value.
#
# The main function is a brute-force approach (which includes checking for invalid characters) to working out the
# ASCII values used in place of variables: a, b and c. Where we each variable can be in the range of [0,255].
def main():
    # Try all possible combinations of ASCII values for the 3 letter key (abc).
    for a in range(0, 256):
        for b in range(0, 256):
            for c in range(0, 256):
                print("a = {0}, b = {1}, c = {2}".format(a, b, c))
                message = {}
                invalid_char = False
                for i in range(0, cipher_size):
                    message[i] = cipher[i]
                    switch_statement = {
                        0: a,
                        1: b,
                        2: c
                    }
                    val = switch_statement[i % 3]
                    message[i] = chr((message[i] - val) % 256)
                    # Check for valid_characters
                    if message[i] not in valid_characters:
                        invalid_char = True
                        break
                if not invalid_char:
                    # Array of chars to string.
                    message_str = ""
                    for x in range(0, len(message)):
                        message_str += str(message[x])
                    # The correct values for a, b and c will contain the wordToMatch in the decrypted plain text.
                    if word_to_match in message_str:
                        print("\nDecrypted Message: " + message_str)
                        print("Key: a = {0}, b = {1}, c = {2}".format(a, b, c))
                        return
    print("\nCould not find a decryption containing: " + wordToMatch)


if __name__ == '__main__':
    main()
