/* Beliefs */

//Checking that a coordinate is within the grid
insideGrid(X,Y) :- gsize(ID,GridX,GridY) & X>=0 & X<GridX & Y>=0 & Y<GridY.

//Set of moves and directions that the agent can take
nxtMove(MinerX,MinerY,up,X,Y) :- X=MinerX & Y=MinerY-1.
nxtMove(MinerX,MinerY,down,X,Y) :- X=MinerX & Y=MinerY+1.
nxtMove(MinerX,MinerY,left,X,Y) :- X=MinerX-1 & Y=MinerY.
nxtMove(MinerX,MinerY,right,X,Y) :- X=MinerX+1 & Y=MinerY.

//Checking that all these condtions are met for the next available move
nxtAvailable(MinerX,MinerY,D,X,Y) :- pos(MinerX,MinerY) & nxtMove(MinerX,MinerY,D,X,Y) & insideGrid(X,Y) & not cell(X,Y,obstacle) & not visited(X,Y) & not cell(X,Y,ally).

//Opposite of each direction
inverse(up,down).
inverse(down,up).
inverse(left,right).
inverse(right,left).


/* Goals */

!goPickUp.


/* Plans */

+goldLocated(X,Y)[source(Agent)]: true <- .print(Agent, " broadcasted ", goldLocated(X,Y)).

//Agent receives broadcasted goldLocated and if it hasn't already been picked up
+!goPickUp : goldLocated(X,Y) & not pickedUp(X,Y)
	<- ?pos(MinerX,MinerY); 
	!attemptMove(X,Y); 
	!tryMine;
	if (carrying_gold) {
	?depot(SimID,Xdepot,Ydepot);
	!attemptMove(Xdepot,Ydepot);
	do(drop);}
	///////////
	.broadcast(tell,pickedUp(X,Y));
	.abolish(goldLocated(X,Y));
	.abolish(pickedUp(X,Y));
	///////////
	!attemptMove(16,17);
	!goPickUp.

//Agent to wait until a gold is located
+!goPickUp : true
	<- !goPickUp.
	
//Agent to try mine if there is gold on the position it is currently at
+!tryMine : pos(MinerX,MinerY) & cell(MinerX,MinerY,gold)
	<- do(pick);
	if (carrying_gold) { 
	+pickedUp(MinerX,MinerY); }
	!tryMine.

//Agent to do nothing if there is no gold on the position it is currently at
+!tryMine : pos(MinerX,MinerY) & not cell(MinerX,MinerY,gold) 
	<- true.
	
//Agent forgets where it has previously been so it has a direct path
+!attemptMove(X,Y) 
	<- .abolish(visited(_,_));
	.abolish(prevMove(_,_,_));
	!moveTo(X,Y).

//Agent to do nothing once it has reached the cell
+!moveTo(X,Y) : pos(X,Y) 
	<- true.

//Agent to do nothing if there is an obstacle at the cell 
+!moveTo(X,Y) : cell(X,Y,obstacle) 
	<- true.
	
//Agent to move to cell that is available and add the current cell to visited and the cell it next moved to prevMove
+!moveTo(X,Y) : pos(MinerX,MinerY) & nxtAvailable(MinerX,MinerY,D,X1,Y1)
	<- +visited(MinerX,MinerY);
	!moveTowards(X,Y);
	+prevMove(X1,Y1,D);
	!moveTo(X,Y).

//Agent to reverse the path in order to get out of a dead end situation
+!moveTo(X,Y) : pos(MinerX,MinerY) & prevMove(MinerX,MinerY,D1) & inverse (D1,D2)
	<- +visited(MinerX,MinerY);
	?cell(AllyX,AllyY,ally)
	if ( AllyX \== MinerX | AllyY \== MinerY) {
		.abolish(visited(_,_));
		if (carrying_gold) { 
		?depot(SimID,Xdepot,Ydepot);
		!attemptMove(Xdepot,Ydepot);
		do(drop); 
		-busy; 
		///////////
		.broadcast(tell,pickedUp(X,Y));
		.abolish(goldLocated(X,Y));
		.abolish(pickedUp(X,Y));
		///////////
		!attemptMove(16,17);
		!goPickUp; }
		else { !goPickUp }
	}
	do(D2);
	!moveTo(X,Y).

//Agent to do nothing once it has moved to the cell
+!moveTo(X,Y)
	<- true.

//Up Left Block
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- if (cell(MinerX-1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- if (cell(MinerX+1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,right).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- if (cell(MinerX-1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");} 
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- if (cell(MinerX,MinerY+1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- if (cell(MinerX+1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,right).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- if (cell(MinerX-1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- if (cell(MinerX,MinerY+1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- if (cell(MinerX+1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,right).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- if (cell(MinerX-1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- if (cell(MinerX+1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- if (cell(MinerX,MinerY+1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,down).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- if (cell(MinerX,MinerY+1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- if (cell(MinerX-1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- if (cell(MinerX+1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,up).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- if (cell(MinerX+1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- if (cell(MinerX-1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- if (cell(MinerX,MinerY+1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,down).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- if (cell(MinerX+1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- if (cell(MinerX,MinerY+1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- if (cell(MinerX-1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,left).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- if (cell(Mi,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- if (cell(MinerX,MinerY+1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- if (cell(MinerX,MinerY-1,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- if (cell(MinerX-1,MinerY,ally) & carrying_gold) {.wait(1000); .print("Waited");}
	!direction(X,Y,left).

+!direction(X,Y,D): pos(MinerX,MinerY) & nxtMove(MinerX,MinerY,D,X1,Y1)
	<- +visited(MinerX,MinerY);
	do(D);
	+prevMove(X1,Y1,D).