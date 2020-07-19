-module(main).
-export([main/0]).

%% Solution to Gambit Quiz, in order to apply for a job with Gambit Research.
%%
%% https://gambitresearch.com/quiz/
%%
%% In the source code found at the above URL, nested within 'div.entry-content',
%% the following JavaScript function can be found:
%%
%% <script type="text/javascript">
%%   // You're on the right path!
%%   function scramble(message, a, b, c) {
%%     return message.split('').map((chr, i) => {
%%       const code = chr.charCodeAt(0)
%%       switch(i % 3) {
%%         case 0: return (code + a) % 256
%%         case 1: return (code + b) % 256
%%         case 2: return (code + c) % 256
%%       }
%%     }).join(' ')
%%   }
%% </script>
%%
%% The cipher text displayed at the above URL is encrypted used a Vigenère (symmetric) cipher, where the key is of
%% length 3 (made up of the variables: a, b and c), and each variable represents an ASCII value.
%%
%% The main function is a brute-force approach to working out the ASCII values used in place
%% of variables: a, b and c. Where each variable can be in the range of [0,255].
%%
%% To execute, run the following command in the same directory: (do not type '$')
%%
%% $ erl
%%
%% Compile the main module, and execute the main function: (do not type '>')
%%
%% > c(main).
%% > main:main().
%%
main() ->
  Cipher = [4, 50, 180, 40, 60, 116, 220, 16, 183, 42, 52, 186, 29, 65, 189, 40, 46, 188, 37, 60, 182, 47, 237,
    174, 43, 63, 104, 47, 60, 180, 50, 54, 182, 35, 237, 188, 36, 50, 104, 3, 46, 181, 30, 54, 188, 220,
    48, 176, 29, 57, 180, 33, 59, 175, 33, 251, 104, 12, 57, 173, 29, 64, 173, 220, 64, 173, 42, 49,
    104, 53, 60, 189, 46, 237, 187, 43, 57, 189, 48, 54, 183, 42, 237, 169, 42, 49, 104, 255, 35, 104,
    48, 60, 104, 37, 48, 169, 42, 48, 183, 32, 50, 136, 35, 46, 181, 30, 54, 188, 46, 50, 187, 33, 46,
    186, 31, 53, 118, 31, 60, 181, 220, 62, 189, 43, 65, 177, 42, 52, 104, 46, 50, 174, 33, 63, 173, 42,
    48, 173, 246, 237, 173, 34, 1, 122, 243, 255, 121, 244, 47, 174],
  CipherSize = length(Cipher),
  WordToMatch = "Gambit",

  %% Try all possible combinations of ASCII values for the 3 letter key (abc).
  io:fwrite("Generating all possible combinations ...."),
  Combos = [{A, B, C} || A <- lists:seq(0, 255), B <- lists:seq(0, 255), C <- lists:seq(0, 255)],
  logic(Combos, Cipher, CipherSize, WordToMatch).

logic([], _Cipher, _CipherSize, WordToMatch) ->
  io:fwrite("~nCould not find a decryption containing: ~p~n", [WordToMatch]);
logic([{A, B, C} | Xs], Cipher, CipherSize, WordToMatch) ->
  io:fwrite("a = ~p, b = ~p, c = ~p~n", [A, B, C]),
  Message = logicHelper(0, Cipher, CipherSize, A, B, C),
  Ok = string:str(Message, WordToMatch) > 0,
  if
    Ok == true ->
      %% The correct values for a, b and c will contain the WordToMatch in the decrypted plain text.
      io:fwrite("~nDecrypted Message: ~p~n", [Message]),
      io:fwrite("Key: a = ~p, b = ~p, c = ~p~n", [A, B, C]);
    true -> logic(Xs, Cipher, CipherSize, WordToMatch)
  end.

logicHelper(I, _Cipher, S, _A, _B, _C) when I == S -> [];
logicHelper(I, [Ci | Cis], S, A, B, C) when I < S ->
  case I rem 3 of
    0 -> [mod((Ci - A), 256)] ++ logicHelper(I + 1, Cis, S, A, B, C);
    1 -> [mod((Ci - B), 256)] ++ logicHelper(I + 1, Cis, S, A, B, C);
    2 -> [mod((Ci - C), 256)] ++ logicHelper(I + 1, Cis, S, A, B, C)
  end.

mod(0, _Y) -> 0;
mod(X, Y) when X > 0 -> X rem Y;
mod(X, Y) when X < 0 -> (X rem Y) + Y.
