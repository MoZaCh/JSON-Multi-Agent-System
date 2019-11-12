//Beliefs

inGrid(A,B) :- gsize(ID,Xg,Yg)
& A>=0
& A<Xg
& B>=0
& B<Yg.



adjacentAvailable(X0,Y0,D,X,Y) :-
	pos(X0,Y0) &
	adjacent(X0,Y0,D,X,Y)
	& inGrid(X,Y) 
	& not cell(X,Y,obstacle)
	& not cell(X,Y,ally)
	& not visited(X,Y).

adjacent(X0,Y0,up,X,Y) :- X=X0 & Y=Y0-1. 
adjacent(X0,Y0,down,X,Y) :- X=X0 & Y=Y0+1.
adjacent(X0,Y0,left,X,Y) :- X=X0-1 & Y=Y0.
adjacent(X0,Y0,right,X,Y) :- X=X0+1 & Y=Y0.


randNumber(R, Max, N) :- N = ((Max-1)*R) div 1.

reverse(up,down).
reverse(down,up).
reverse(left,right).
reverse(right,left).

//Goal
!scanNugget.

//Plans of agent
+pickedUp(X,Y): goldLocated(X,Y) 
	<- .abolish(goldLocated(X,Y));
	.abolish(pickedUp(X,Y)).

+!scanNugget : not cell(X,Y,gold) | cell(X,Y,gold) & goldLocated(X,Y)
	<- ?pos(X0,Y0); !furtherRandom; !scanNugget.
	
+!scanNugget : cell(X,Y,gold) & not goldLocated(X,Y)
	<- ?pos(X0,Y0);
!attemptToGo(X,Y);
!scanNugget.
	   
	   
	   
+!furtherRandom : .random(RX) & .random(RY) 
	& gsize(ID,W, H) &
    randNumber(RX, W, X) & randNumber(RY, H, Y)
	& not cleaned(X,Y)
	<- !attemptToGo(X,Y).

+!furtherRandom <- !furtherRandom.

// if he has already visited that position abolish the memory
+!attemptToGo(X,Y) 
	<- .abolish(visited(_,_)); .abolish(preMove(_,_,_)); !departTo(X,Y).

+!departTo(X,Y) : pos(X,Y)	
	<- true.


+!departTo(X,Y) : cell(X,Y,obstacle) <- true.

+!departTo(X,Y) : pos(X0,Y0) & adjacentAvailable(X0,Y0,D,X1,Y1)
	<- +visited(X0,Y0); !getCloser(X,Y); +preMove(X1,Y1,D); !departTo(X,Y).
	
+!departTo(X,Y) : pos(X0,Y0) & preMove(X0,Y0,D1) & reverse(D1,D2)
	<- +visited(X0,Y0); do(D2); !departTo(X,Y).

+!departTo(X,Y) <- true.

//Movement po¨
+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y==Y0 & adjacentAvailable(X0,Y0,right,_,_)
<- !direction(X,Y,right).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y==Y0 & adjacentAvailable(X0,Y0,up,_,_)
<- !direction(X,Y,up).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y==Y0 & adjacentAvailable(X0,Y0,down,_,_)
<- !direction(X,Y,down).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y==Y0 & adjacentAvailable(X0,Y0,left,_,_)
<- !direction(X,Y,left).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y>Y0 & adjacentAvailable(X0,Y0,right,_,_)
<- !direction(X,Y,right).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y>Y0 & adjacentAvailable(X0,Y0,down,_,_)
<- !direction(X,Y,down).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y>Y0 & adjacentAvailable(X0,Y0,up,_,_)
<- !direction(X,Y,up).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y>Y0 & adjacentAvailable(X0,Y0,left,_,_)
<- !direction(X,Y,left).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y<Y0 & adjacentAvailable(X0,Y0,left,_,_)
<- !direction(X,Y,left).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y<Y0 & adjacentAvailable(X0,Y0,up,_,_)
<- !direction(X,Y,up).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y<Y0 & adjacentAvailable(X0,Y0,down,_,_)
<- !direction(X,Y,down).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y<Y0 & adjacentAvailable(X0,Y0,right,_,_)
<- !direction(X,Y,right).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y==Y0 & adjacentAvailable(X0,Y0,left,_,_)
<- !direction(X,Y,left).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y==Y0 & adjacentAvailable(X0,Y0,up,_,_)
<- !direction(X,Y,up).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y==Y0 & adjacentAvailable(X0,Y0,down,_,_)
<- !direction(X,Y,down).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y==Y0 & adjacentAvailable(X0,Y0,right,_,_)
<- !direction(X,Y,right).

+!getCloser(X,Y):
pos(X0,Y0) & X==X0 & Y>Y0 & adjacentAvailable(X0,Y0,down,_,_)
<- !direction(X,Y,down).

+!getCloser(X,Y):
pos(X0,Y0) & X==X0 & Y>Y0 & adjacentAvailable(X0,Y0,left,_,_)
<- !direction(X,Y,left).

+!getCloser(X,Y):
pos(X0,Y0) & X==X0 & Y>Y0 & adjacentAvailable(X0,Y0,right,_,_)
<- !direction(X,Y,right).

+!getCloser(X,Y):
pos(X0,Y0) & X==X0 & Y>Y0 & adjacentAvailable(X0,Y0,up,_,_)
<- !direction(X,Y,up).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y<Y0 & adjacentAvailable(X0,Y0,up,_,_)
<- !direction(X,Y,up).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y<Y0 & adjacentAvailable(X0,Y0,right,_,_)
<- !direction(X,Y,right).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y<Y0 & adjacentAvailable(X0,Y0,left,_,_)
<- !direction(X,Y,left).

+!getCloser(X,Y):
pos(X0,Y0) & X>X0 & Y<Y0 & adjacentAvailable(X0,Y0,down,_,_)
<- !direction(X,Y,down).


+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y>Y0 & adjacentAvailable(X0,Y0,left,_,_)
<- !direction(X,Y,left).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y>Y0 & adjacentAvailable(X0,Y0,down,_,_)
<- !direction(X,Y,down).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y>Y0 & adjacentAvailable(X0,Y0,up,_,_)
<- !direction(X,Y,up).

+!getCloser(X,Y):
pos(X0,Y0) & X<X0 & Y>Y0 & adjacentAvailable(X0,Y0,right,_,_)
<- !direction(X,Y,right).

+!getCloser(X,Y): 
pos(X0,Y0) & X==X0 & Y<Y0 & adjacentAvailable(X0,Y0,up,_,_) 
<- !direction(X,Y,up).

+!getCloser(X,Y):
pos(X0,Y0) & X==X0 & Y<Y0 & adjacentAvailable(X0,Y0,left,_,_)
<- !direction(X,Y,left).

+!getCloser(X,Y):
pos(X0,Y0) & X==X0 & Y<Y0 & adjacentAvailable(X0,Y0,right,_,_)
<- !direction(X,Y,right).

+!getCloser(X,Y):
pos(X0,Y0) & X==X0 & Y<Y0 & adjacentAvailable(X0,Y0,down,_,_)
<- !direction(X,Y,down).


+!direction(X,Y,D):                  
pos(X0,Y0) & adjacent(X0,Y0,D,X1,Y1)
	<- +visited(X0,Y0);
	//if there is gold broadcast it to everyone
	if(cell(A,B,gold) & not goldLocated(A,B)){
	.broadcast(tell,goldLocated(A,B));
	+goldLocated(A,B)
	.print(goldLocated(A,B));
	}
	
	//Go in direction D
	do(D); +preMove(X1,Y1,D).

