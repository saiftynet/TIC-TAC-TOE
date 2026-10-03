#!/usr/bin/env perl
###########   TIC TAC TOE   ##############
#    A demo of the minimax algorithm     #
#    producing an unbeatable TicTacToe   #
#    player                              #
##########################################                            
use strict; use warnings;

my $board=[0,(0) x 9];
my $pl="X";
my $userFirst=0;
my $c=$userFirst?0:1;my $inp;

while (1){# game loop
  
  unless($c++==0){  # computer first 
    my $nextMove=minimax($board,$pl);
    last unless $nextMove->{move};
    $board->[$nextMove->{move}]=$pl;
  }
  drawBoard($board);
  last if victory($board) || ! scalar emptyCells($board);
  
  print "Available cells = ",emptyCells($board),"\n";
  print "Enter location or q to quit;";
  while ($inp = <STDIN>){  # user input
    chomp $inp;
    exit(0) if $inp eq "q";
    if ( $inp !~/^\d$/  || $board->[$inp]){
      print "\"$inp\" is Invalid \n" ;
    }
    else{
      $board->[$inp]="O";
      last;
    }
  };  
  drawBoard($board);
  last if victory($board) || ! scalar emptyCells($board);

};

# no more empty cells or somebody has won;
print "\nGame Over\n";
my $res=victory($board);
print $res==10?"Computer Wins":($res==-10?" You win": "Draw");

# given a 3 X 3 board numbered 1..9 checks rows, columns
# and diagonals
sub victory{
   my $state=shift;
   my $check=join("",@$state[1,2,3,0,4,5,6,0,7,8,9,0,
                                1,4,7,0,2,5,8,0,3,6,9,0,
                                1,5,9,0,3,5,7])=~/(X{3}|O{3})/;  
  return $1?{XXX=>10,OOO=>-10}->{$1}:0;
}

#  returns a list of empty cells;
sub emptyCells{
  my $state=shift;
  return map{ $state->[$_]?():$_}(1..9);  
}

# a simple minimax algorithm for choosing the best next move for a player
# give current state of board.  In this model, "X" is maximising "O"
# is minimising

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

sub drawBoard{  # print 
  my $brd=shift;
  system $^O eq 'MSWin32' ? 'cls' : 'clear';
  my $output="       TIC TAC TOE\n    ┌────┬────┬────┐
    │ $brd->[1]  │ $brd->[2]  │ $brd->[3]  │
    │   1│   2│   3│
    ├────┼────┼────┤
    │ $brd->[4]  │ $brd->[5]  │ $brd->[6]  │
    │   4│   5│   6│
    ├────┼────┼────┤
    │ $brd->[7]  │ $brd->[8]  │ $brd->[9]  │
    │   7│   8│   9│
    └────┴────┴────┘\n";
  $output=~s/0/ /g;
  print $output;
}

