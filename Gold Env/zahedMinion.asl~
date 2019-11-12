//Beliefs

//Checking that a coordinate is within the grid
inGrid(X,Y) :- gsize(ID,GridX,GridY) & X>=0 & X<GridX & Y>=0 & Y<GridY.

//Set of moves and directions that the agent can take
nxtMove(MinerX,MinerY,up,X,Y) :- X=MinerX & Y=MinerY-1.
nxtMove(MinerX,MinerY,down,X,Y) :- X=MinerX & Y=MinerY+1.
nxtMove(MinerX,MinerY,left,X,Y) :- X=MinerX-1 & Y=MinerY.
nxtMove(MinerX,MinerY,right,X,Y) :- X=MinerX+1 & Y=MinerY.

nxtAvailable(MinerX,MinerY,D,X,Y) :- pos(MinerX,MinerY) & nxtMove(MinerX,MinerY,D,X,Y) & inGrid(X,Y) & not cell(X,Y,obstacle) & not visited(X,Y) & not cell(X,Y,ally).

//Oposite of each direction
inverse(up,down).
inverse(down,up).
inverse(left,right).
inverse(right,left).

//Random number
randomNum(R, Max, N) :- N = ((Max-1)*R) div 1.

//Goals
!locateGold.


//Plans
+!nxtRandom : .random(RX) & .random(RY) & gsize(ID, W, H) &
    randomNum(RX, W, X) & randomNum(RY, H, Y) & not visited(X,Y)
	<- !attemptMove(X,Y).
	
+!nxtRandom <- !nxtRandom.

+!locateGold : cell(X,Y,gold)
	<- ?pos(MinerX,MinerY); 
	//.send(zahedLeader,tell,goldLocated(X,Y));
	//if (not goldLocated(X,Y)) { .broadcast(tell, goldLocated(X,Y)); +goldLocated(X,Y); }
	!nxtRandom;
	!locateGold.

+!locateGold : not cell(X,Y,gold)
	<- !nxtRandom;
	!locateGold.

//+!locateGold : cell(X,Y,gold) & goldLocated(X,Y)
	//<- !nxtRandom;
	//!locateGold.

+!attemptMove(X,Y) 
	<- .abolish(visited(_,_));
	.abolish(preMove(_,_,_));
	!moveTo(X,Y).

+!moveTo(X,Y) : pos(X,Y) 
	<- true.
	
+!moveTo(X,Y) : cell(X,Y,obstacle) 
	<- true.
	
+!moveTo(X,Y) : pos(MinerX,MinerY) & nxtAvailable(MinerX,MinerY,D,X1,Y1)
	<- +visited(MinerX,MinerY);
	!moveTowards(X,Y);
	+preMove(X1,Y1,D);
	!moveTo(X,Y).
	
+!moveTo(X,Y) : pos(MinerX,MinerY) & preMove(MinerX,MinerY,D1) & inverse(D1,D2)
	<- +visited(MinerX,MinerY);
	?cell(Xa,Ya,ally)
	if ( Xa \== MinerX | Ya \== MinerY) {
		.abolish(visited(_,_));
		!locateGold;
	}
	do(D2);
	!moveTo(X,Y).
	
+!moveTo(X,Y)
	<- true.
	
//Left Block
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & nxtAvailable(MinerX,MinerY,left,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & nxtAvailable(MinerX,MinerY,up,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & nxtAvailable(MinerX,MinerY,down,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & nxtAvailable(MinerX,MinerY,right,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,right).

//Up Block
+!moveTowards(X,Y): pos(MinerX,MinerY) & Y<MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & Y<MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & Y<MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & Y<MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,down).

//Down Block
+!moveTowards(X,Y): pos(MinerX,MinerY) & Y>MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & Y>MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & Y>MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & Y>MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,up).

//Right Block
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & nxtAvailable(MinerX,MinerY,right,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & nxtAvailable(MinerX,MinerY,up,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & nxtAvailable(MinerX,MinerY,down,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & nxtAvailable(MinerX,MinerY,left,_,_) 
		<- if (cell(MovX,MovY,gold) & not goldLocated(MovX,MovY)) {.broadcast(tell, goldLocated(MovX,MovY)); +goldLocated(MovX,MovY); }
	!direction(X,Y,left).


+!direction(X,Y,D): pos(MinerX,MinerY) & nxtMove(MinerX,MinerY,D,X1,Y1)
	<- +visited(MinerX,MinerY);
	do(D);
	+preMove(X1,Y1,D).
	
+goldLocated(X,Y)[source(Agent)]: true <- .print(Agent, " broadcasted ", goldLocated(X,Y)).
