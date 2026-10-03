# TIC-TAC-TOE
###  A Tic Tac Toe game and experiments using MiniMax algorithm

<img width="310" height="276" alt="tictactoe" src="https://github.com/user-attachments/assets/1aedc6be-3a08-4335-a247-75a70da9a4a8" />


### Introduction
Plenty of Tic Tac Toe game implementations exists in Perl. This is a simple implementation of
Tic Tac Toe, using Perlish methods to evaluate the game board. The game state is an array
containing a 0 representing each empty cell and a 0 at cell zero, allowing simply setting
the position with "X" or "O" to represent a move.
```
my $board=[0,(0) x 9];
```


A simple `join` of every possible winning sequence as an array slice is searched using a simple regex
```
sub victory{
   my $state=shift;
   my $check=join("",@$state[1,2,3,0,4,5,6,0,7,8,9,0,
                                1,4,7,0,2,5,8,0,3,6,9,0,
                                1,5,9,0,3,5,7])=~/(X{3}|O{3})/;  
  return $1?{XXX=>10,OOO=>-10}->{$1}:0;
}
```


The [MiniMax](https://en.wikipedia.org/wiki/Minimax) algorithm is a derivation of examples presented [elsewhere](https://jacoby.github.io/2020/03/16/minimax-british-coins-and-oldschool-ai-in-perl.html) (but not so far seen in actual Perl Code).
This algorithm is a search for a best move in a turn based game, where the options are explored, and the terminal scores for each decision returned, with one player hoping to achieve the highest score and the other targeting the lowest score.  Typically the starting score 
is set at + of - infinity; this appears not to be necessary for TicTacToe.

```
sub minimax{
  my ($state,$player,$depth)=@_;
  my $other=$player eq "X"?"O":"X";
  $depth//=4;
  my $end=victory($state);
  return {score=>$end} if ($end || ! scalar emptyCells($state)  );
  
  my $scores={};     # hash to store the scores and moves
  foreach my $tryMove(emptyCells($state)){
      $state->[$tryMove]=$player;
      $scores->{$tryMove}=minimax($state,$other,$depth-1)->{score};
      $state->[$tryMove]=0;
  };
  my @moves=sort { $scores->{$a} <=> $scores->{$b} } keys(%$scores);
  return $player eq "X"?{move=>$moves[-1],score=>$scores->{$moves[-1]}}:
                        {move=>$moves[0],score=>$scores->{$moves[0]}}
}
```


### Acknowledgements
[Demonstrating PERL with Tic-Tac-Toe br G Bartholomew](https://fedoramagazine.org/demonstrating-perl-with-tic-tac-toe-part-1/)

[Games-TicTacToe by MANWAR](https://metacpan.org/dist/Games-TicTacToe)

[Rosetta Code](https://rosettacode.org/wiki/Tic-tac-toe#Perl)






