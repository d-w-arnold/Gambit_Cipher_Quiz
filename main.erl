-module(main).
-export([main/0]).

%%
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
main() ->
  Cipher = [171, 78, 209, 207, 88, 145, 131, 44, 212, 209, 80, 215, 196, 93, 218, 207, 74, 217, 204, 88, 211, 214, 9, 203, 210, 91, 133, 214, 88, 209, 217, 82, 211, 202, 9, 217, 203, 78, 133, 170, 74, 210, 197, 82, 217, 131, 76, 205, 196, 85, 209, 200, 87, 204, 200, 23, 133, 179, 85, 202, 196, 92, 202, 131, 92, 202, 209, 77, 133, 220, 88, 218, 213, 9, 216, 210, 85, 218, 215, 82, 212, 209, 9, 198, 209, 77, 133, 166, 63, 133, 215, 88, 133, 204, 76, 198, 209, 76, 212, 199, 78, 165, 202, 74, 210, 197, 82, 217, 213, 78, 216, 200, 74, 215, 198, 81, 147, 198, 88, 210, 131, 90, 218, 210, 93, 206, 209, 80, 133, 213, 78, 203, 200, 91, 202, 209, 76, 202, 157, 9, 199, 154, 32, 155, 200, 33, 155, 199, 33, 154],
  CipherSize = length(Cipher),
  WordToMatch = "Gambit",

  %% Try all possible combinations of ASCII values for the 3 letter key (abc).
  %% i.e. {Current index, End index inclusive)
  nestedLoops({0, 255}, {0, 255}, {0, 255}, Cipher, CipherSize, WordToMatch).

%% Three nested for loops
nestedLoops(A, {BC, BE}, {CC, CE}, Ci, CiS, WTM) when CC == (CE + 1) ->
  nestedLoops(A, {BC + 1, BE}, {0, CE}, Ci, CiS, WTM);
nestedLoops({AC, AE}, {BC, BE}, C, Ci, CiS, WTM) when BC == (BE + 1) ->
  nestedLoops({AC + 1, AE}, {0, BE}, C, Ci, CiS, WTM);
nestedLoops(A, B, C, Ci, CiS, WTM) -> logic(A, B, C, Ci, CiS, WTM).

logic({AC, AE}, {BC, BE}, {CC, CE}, Ci, CiS, WTM) ->
  io:fwrite("a = ~p, b = ~p, c = ~p~n", [AC, BC, CC]),
  Msg = logicHelper(0, Ci, CiS, AC, BC, CC),
  Ok = string:str(Msg, WTM) > 0,
  if
    Ok == true ->
      %% The correct values for a, b and c will contain the WordToMatch in the decrypted plain text.
      io:fwrite("~nDecrypted Message: ~p~n", [Msg]),
      io:fwrite("Key: a = ~p, b = ~p, c = ~p~n", [AC, BC, CC]),
      init:stop();
    true ->
      if
        AC == AE, BC == BE, CC == CE ->
          io:fwrite("~nCould not find a decryption containing: ~p~n", [WTM]),
          init:stop();
        true -> nestedLoops({AC, AE}, {BC, BE}, {CC + 1, CE}, Ci, CiS, WTM)
      end
  end.

logicHelper(I, _Ci, CiS, _A, _B, _C) when I == CiS -> [];
logicHelper(I, [CiH | CiT], CiS, A, B, C) when I < CiS ->
  case I rem 3 of
    0 -> [mod((CiH - A), 256)] ++ logicHelper(I + 1, CiT, CiS, A, B, C);
    1 -> [mod((CiH - B), 256)] ++ logicHelper(I + 1, CiT, CiS, A, B, C);
    2 -> [mod((CiH - C), 256)] ++ logicHelper(I + 1, CiT, CiS, A, B, C)
  end.

mod(0, _Y) -> 0;
mod(X, Y) when X > 0 -> X rem Y;
mod(X, Y) when X < 0 -> (X rem Y) + Y.
