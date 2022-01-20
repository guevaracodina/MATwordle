function MATwordle
% MATLAB adaptation of Wordle https://www.powerlanguage.co.uk/wordle/
% Guess the hidden word in 6 tries.
% Each guess must be a valid 5-letter word. Hit the enter button to input.
% After each guess, the color of the letters will change to show how close
% your guess was to the word.
% If the letter is green, then it is in the word and in the correct spot.
% If the letter is orange, then it is in the word but in the wrong spot.
% If the letter is black, then it is not in the word in any spot.
%
% SYNTAX
% MATWORDLE
%
% INPUTS
% none
%
% OUTPUTS
% none
% REQUIRED CODE
% cprintf available from
% https://www.mathworks.com/matlabcentral/fileexchange/24093-cprintf-display-formatted-colored-text-in-command-window
% _______________________________________________________________________________
% Copyright (C) 2022 Edgar Guevara, PhD
% _______________________________________________________________________________
clear; close all; clc
load('MATwordleData.mat','allowedGuesses','wordleAnswers')
addpath(genpath('..\cprintf'))  % Uses cprintf
desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
desktop.closeWorkspaceBrowser;  % Close workspace window to avoid cheating
nLetters = 5;                   % Only 5-letter words
nGuessesMax = 6;                % Maximum number of guesses
rng('shuffle')
% rng(1, 'twister');              % For repeatability
% idxMATwordle = randi(numel(wordleAnswers));
idxMATwordle = 1607;
word2Guess = wordleAnswers(idxMATwordle);
word2GuessChar = char(word2Guess);
nGuesses = 0;
gameWon = false;
clc
fprintf('Welcome to MATWordle Version 0.1\nInput only %d-letter words\n', nLetters)
while nGuesses < nGuessesMax
    myGuess = input(sprintf('Guess %d of %d: ',...
        nGuesses+1, nGuessesMax),'s');
    if any(strcmp(myGuess, allowedGuesses)) || any(strcmp(myGuess, wordleAnswers))
        word2GuessCharCorrect = false([1 nLetters]);
        remainingWord2GuessChar = word2GuessChar;
        colorsArray = repmat({[0,0,0]},1,nLetters); % Black
        % Check correct letter one by one
        for iLetters = 1:nLetters
            if myGuess(iLetters) == word2GuessChar(iLetters)
                word2GuessCharCorrect(iLetters) = true;
                colorsArray{iLetters} = [0,1,0];    % Green
            end
        end
        remainingWord2GuessChar = word2GuessChar(~word2GuessCharCorrect);
        % Check correct letter in the wrong spot
        for iLetters = 1:nLetters
            if any(myGuess(iLetters) == remainingWord2GuessChar) && ~word2GuessCharCorrect(iLetters)
                remainingWord2GuessChar(remainingWord2GuessChar==myGuess(iLetters)) = [];
                colorsArray{iLetters} = [1,0.5,0];  % Orange
            end
        end
        % Display results
        for iLetters = 1:nLetters
            cprintf(colorsArray{iLetters}, ' %c ', myGuess(iLetters));
        end
        nGuesses = nGuesses + 1;
        fprintf('\n')
        if strcmp(myGuess, word2Guess)
            fprintf('MATwordle %d %d/%d\nCongratulations!\n', idxMATwordle, nGuesses, nGuessesMax)
            gameWon = true;
            break
        end
    end
end
if ~gameWon
    %     fprintf('The word was %s\n', word2Guess)
    fprintf('MATwordle %d\nG A M E   O V E R\n', idxMATwordle);
end
end