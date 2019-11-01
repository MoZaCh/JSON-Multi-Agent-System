//Beliefs

inGrid(X,Y) :- grid(GridX,GridY) & X>=0 & X<GridX & Y>=0 & Y<GridY. //Checking that a coordination is within the grid

nextMove(MinerX,MinerY,up,X,Y) :- X=MinerX & Y=MinerY-1. //Move up
nextMove(MinerX,MinerY,down,X,Y) :- X=MinerX & Y=MinerY+1. //Move down
nextMove(MinerX,MinerY,left,X,Y) :- X=MinerX-1 & Y=MinerY. //Move left
nextMove(MinerX,MinerY,right,X,Y) :- X=MinerX+1 & Y=MinerY. //Move right


nextAvailableMove(MinerX,MinerY,D,X,Y) :- pos(MinerX,MinerY) & nextMove(MinerX,MinerY,D,X,Y) & inGrid(X,Y) & not obs(X,Y) & not visited(X,Y). //Determines the best cell to pick
	
inverse(up,down). //Belief that the inverse of a specific direction
inverse(down,up).
inverse(left,right).
inverse(right,left).

randomNumber(R, Max, N) :- N = ((Max-1)*R) div 1.  //Generates a random cell to move to

//Goals
!clean.

//Plans

+!clean : not garb(X,Y) <- ?pos(MinerX,MinerY); !nextRandom; !clean.
	
+!clean : garb(X,Y) <- ?pos(MinerX,MinerY); !tryGoTo(X,Y); !tryPick; +busy; ?depot(Xd,Yd); !tryGoTo(Xd,Yd); drop(garb); -busy; !clean.
	   
+!nextRandom : .random(RX) & .random(RY) & grid(W, H) & randomNumber(RX, W, X) & randomNumber(RY, H, Y) & not visited(X,Y) <- !tryGoTo(X,Y).
+!nextRandom <- !nextRandom.
	
+!tryPick : pos(MinerX,MinerY) & garb(MinerX,MinerY) <- pick(garb); !tryPick.
+!tryPick : pos(MinerX,MinerY) & not garb(MinerX,MinerY) <- true.   

+!tryGoTo(X,Y) <- .abolish(visited(_,_)); .abolish(preMove(_,_,_)); !goTo(X,Y).

+!goTo(X,Y) : pos(X,Y) <- true.
+!goTo(X,Y) : obs(X,Y) <- true.
+!goTo(X,Y) : not garb(X,Y) & garb(GridX,GridY) & not busy <- true.
+!goTo(X,Y) : pos(MinerX,MinerY) & nextAvailableMove(MinerX,MinerY,D,X1,Y1)
	<- +visited(MinerX,MinerY); !goTowards(X,Y); +preMove(X1,Y1,D); !goTo(X,Y).
+!goTo(X,Y) : pos(MinerX,MinerY) & preMove(MinerX,MinerY,D1) & inverse(D1,D2)
	<- +visited(MinerX,MinerY); move(D2); !goTo(X,Y).
+!goTo(X,Y) <- true.

+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,right,_,_) <- !direction(X,Y,right).

+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nextAvailableMove(MinerX,MinerY,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nextAvailableMove(MinerX,MinerY,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nextAvailableMove(MinerX,MinerY,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nextAvailableMove(MinerX,MinerY,right,_,_) <- !direction(X,Y,right).

+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,right,_,_) <- !direction(X,Y,right).

+!goTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,down,_,_) <- !direction(X,Y,down).

+!goTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,up,_,_) <- !direction(X,Y,up).

+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nextAvailableMove(MinerX,MinerY,down,_,_) <- !direction(X,Y,down).

+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nextAvailableMove(MinerX,MinerY,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nextAvailableMove(MinerX,MinerY,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nextAvailableMove(MinerX,MinerY,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nextAvailableMove(MinerX,MinerY,left,_,_) <- !direction(X,Y,left).

+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nextAvailableMove(MinerX,MinerY,left,_,_) <- !direction(X,Y,left).

+!direction(X,Y,D): pos(MinerX,MinerY) & nextMove(MinerX,MinerY,D,X1,Y1)
	<- +visited(MinerX,MinerY); move(D); +preMove(X1,Y1,D).
