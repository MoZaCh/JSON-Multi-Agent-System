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
//randomNum(R, Max, N) :- N = ((Max-1)*R) div 1.

//Goals
//!locateGold.

//!moveToDepot.
!goPickUp.

//Plans
//+!locateGold : not cell(X,Y,gold)
	//<- ?pos(MinerX,MinerY); 
	//!nxtRandom; 
	//!locateGold.
//+!moveToDepot : pos(MinerX,MinerY) & depot(SimID,Xd,Yd)
	//<- !attemptMove(Xd,Yd);
	//+!goPickUp;
	//.print("Reached the depot");
	//+!goPickUp.
	
+goldLocated(X,Y)[source(Agent)]: true <- .print(Agent, " broadcasted ", goldLocated(X,Y)).

+!goPickUp : goldLocated(X,Y) & not pickedUp(X,Y)
	<- ?pos(MinerX,MinerY); 
	!attemptMove(X,Y); 
	!tryMine;
	?depot(SimID,Xd,Yd);
	!attemptMove(Xd,Yd);
	.print("before");
	do(drop);
	while(carrying_gold) { do(drop); }
	.print("finally");
	//.abolish(goldLocated(X,Y));
	!attemptMove(16,17);
	!goPickUp.

+!goPickUp : true
	<- !goPickUp.

+!tryMine : pos(MinerX,MinerY) & cell(MinerX,MinerY,gold)
	<- do(pick);
	if (carrying_gold) { +pickedUp(MinerX,MinerY); }
	//+pickedUp(MinerX,MinerY);
	!tryMine.
	
+!tryMine : pos(MinerX,MinerY) & not cell(MinerX,MinerY,gold) 
	<- true.
	
	
+!attemptMove(X,Y) 
	<- .abolish(visited(_,_));
	.abolish(preMove(_,_,_));
	!moveTo(X,Y).

+!moveTo(X,Y) : pos(X,Y) 
	<- true.
	
+!moveTo(X,Y) : cell(X,Y,obstacle) 
	<- true.
	
//+!moveTo(X,Y) : not cell(X,Y,gold) & cell(GridX,GridY,gold) & not busy 
	//<- true.
	
+!moveTo(X,Y) : pos(MinerX,MinerY) & nxtAvailable(MinerX,MinerY,D,X1,Y1)
	<- +visited(MinerX,MinerY);
	!moveTowards(X,Y);
	+preMove(X1,Y1,D);
	!moveTo(X,Y).
	
+!moveTo(X,Y) : pos(MinerX,MinerY) & preMove(MinerX,MinerY,D1) & inverse (D1,D2)
	<- +visited(MinerX,MinerY);
	//?cell(Xa,Ya,ally)
	//if ( Xa \== MinerX | Ya \== MinerY) {
		//.abolish(visited(_,_));
		//if (carrying_gold) { ?depot(SimID,Xd,Yd); !attemptMove(Xd,Yd); do(drop); -busy; !goPickUp; }
		//else { !goPickUp }
	//}
	do(D2);
	!moveTo(X,Y).
	
+!moveTo(X,Y) 
	<- true.

+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- !direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- !direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- !direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- !direction(X,Y,right).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- !direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- !direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- !direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- !direction(X,Y,right).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- !direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- !direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- !direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X<MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- !direction(X,Y,right).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- !direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- !direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- !direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- !direction(X,Y,down).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- !direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- !direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- !direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X==MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- !direction(X,Y,up).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- !direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- !direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- !direction(X,Y,left).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y<MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- !direction(X,Y,down).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- !direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- !direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- !direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y==MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- !direction(X,Y,left).

+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,right,_,_) 
	<- !direction(X,Y,right).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,down,_,_) 
	<- !direction(X,Y,down).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,up,_,_) 
	<- !direction(X,Y,up).
+!moveTowards(X,Y): pos(MinerX,MinerY) & X>MinerX & Y>MinerY & nxtAvailable(MinerX,MinerY,left,_,_) 
	<- !direction(X,Y,left).

+!direction(X,Y,D): pos(MinerX,MinerY) & nxtMove(MinerX,MinerY,D,X1,Y1)
	<- +visited(MinerX,MinerY);
	do(D);
	+preMove(X1,Y1,D).
