from string import digits, ascii_letters, punctuation

valid_characters = digits + ascii_letters + punctuation + " "
cipher = [171, 78, 209, 207, 88, 145, 131, 44, 212, 209, 80, 215, 196, 93, 218, 207, 74, 217, 204, 88, 211, 214, 9, 203, 210, 91, 133, 214, 88, 209, 217, 82, 211, 202, 9, 217, 203, 78, 133, 170, 74, 210, 197, 82, 217, 131, 76, 205, 196, 85, 209, 200, 87, 204, 200, 23, 133, 179, 85, 202, 196, 92, 202, 131, 92, 202, 209, 77, 133, 220, 88, 218, 213, 9, 216, 210, 85, 218, 215, 82, 212, 209, 9, 198, 209, 77, 133, 166, 63, 133, 215, 88, 133, 204, 76, 198, 209, 76, 212, 199, 78, 165, 202, 74, 210, 197, 82, 217, 213, 78, 216, 200, 74, 215, 198, 81, 147, 198, 88, 210, 131, 90, 218, 210, 93, 206, 209, 80, 133, 213, 78, 203, 200, 91, 202, 209, 76, 202, 157, 9, 199, 154, 32, 155, 200, 33, 155, 199, 33, 154]
cipher_size = len(cipher)
word_to_match = "Gambit"


#
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
# The main function is a brute-force approach to working out the ASCII values used in place
# of variables: a, b and c. Where each variable can be in the range of [0,255].
#
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
                    # The correct values for a, b and c will contain the word_to_match in the decrypted plain text.
                    if word_to_match in message_str:
                        print("\nDecrypted Message: " + message_str)
                        print("Key: a = {0}, b = {1}, c = {2}".format(a, b, c))
                        return
    print("\nCould not find a decryption containing: " + word_to_match)


if __name__ == '__main__':
    main()
