//Beliefs

inGrid(X,Y) :- grid(Xg,Yg) & X>=0 & X<Xg & Y>=0 & Y<Yg.

next(X0,Y0,up,X,Y) :- X=X0 & Y=Y0-1. 
next(X0,Y0,down,X,Y) :- X=X0 & Y=Y0+1.
next(X0,Y0,left,X,Y) :- X=X0-1 & Y=Y0.
next(X0,Y0,right,X,Y) :- X=X0+1 & Y=Y0.

nextAvailable(X0,Y0,D,X,Y) :-
	pos(X0,Y0) & next(X0,Y0,D,X,Y) & inGrid(X,Y) & not obs(X,Y) & not visited(X,Y).
	
opposite(up,down).
opposite(down,up).
opposite(left,right).
opposite(right,left).

//Goals
!clean.

//Plans

+!clean : not garb(X,Y)
	<- ?pos(X0,Y0); ?nextAvailable(X0,Y0,D,X,Y); !tryGoTo(X,Y); !clean.
	
+!clean : garb(X,Y)
	<- ?pos(X0,Y0); !tryGoTo(X,Y); !tryPick; ?depot(Xd,Yd); 
	   !tryGoTo(Xd,Yd); drop(garb); !clean.

+!tryPick : pos(X0,Y0) & garb(X0,Y0) <- pick(garb); !tryPick.
+!tryPick : pos(X0,Y0) & not garb(X0,Y0) <- true.   

+!tryGoTo(X,Y) 
	<- .abolish(visited(_,_)); .abolish(preMove(_,_,_)); !goTo(X,Y).

+!goTo(X,Y) : pos(X,Y) <- true.
+!goTo(X,Y) : obs(X,Y) <- true.
+!goTo(X,Y) : pos(X0,Y0) & nextAvailable(X0,Y0,D,X1,Y1)
	<- +visited(X0,Y0); !goTowards(X,Y); +preMove(X1,Y1,D); !goTo(X,Y).
+!goTo(X,Y) : pos(X0,Y0) & preMove(X0,Y0,D1) & opposite(D1,D2)
	<- +visited(X0,Y0); move(D2); !goTo(X,Y).
+!goTo(X,Y) <- true.

+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y<Y0 & nextAvailable(X0,Y0,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y<Y0 & nextAvailable(X0,Y0,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y<Y0 & nextAvailable(X0,Y0,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y<Y0 & nextAvailable(X0,Y0,right,_,_) <- !direction(X,Y,right).

+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y==Y0 & nextAvailable(X0,Y0,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y==Y0 & nextAvailable(X0,Y0,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y==Y0 & nextAvailable(X0,Y0,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y==Y0 & nextAvailable(X0,Y0,right,_,_) <- !direction(X,Y,right).

+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y>Y0 & nextAvailable(X0,Y0,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y>Y0 & nextAvailable(X0,Y0,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y>Y0 & nextAvailable(X0,Y0,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(X0,Y0) & X<X0 & Y>Y0 & nextAvailable(X0,Y0,right,_,_) <- !direction(X,Y,right).

+!goTowards(X,Y): pos(X0,Y0) & X==X0 & Y<Y0 & nextAvailable(X0,Y0,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(X0,Y0) & X==X0 & Y<Y0 & nextAvailable(X0,Y0,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(X0,Y0) & X==X0 & Y<Y0 & nextAvailable(X0,Y0,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(X0,Y0) & X==X0 & Y<Y0 & nextAvailable(X0,Y0,down,_,_) <- !direction(X,Y,down).

+!goTowards(X,Y): pos(X0,Y0) & X==X0 & Y>Y0 & nextAvailable(X0,Y0,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(X0,Y0) & X==X0 & Y>Y0 & nextAvailable(X0,Y0,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(X0,Y0) & X==X0 & Y>Y0 & nextAvailable(X0,Y0,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(X0,Y0) & X==X0 & Y>Y0 & nextAvailable(X0,Y0,up,_,_) <- !direction(X,Y,up).

+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y<Y0 & nextAvailable(X0,Y0,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y<Y0 & nextAvailable(X0,Y0,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y<Y0 & nextAvailable(X0,Y0,left,_,_) <- !direction(X,Y,left).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y<Y0 & nextAvailable(X0,Y0,down,_,_) <- !direction(X,Y,down).

+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y==Y0 & nextAvailable(X0,Y0,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y==Y0 & nextAvailable(X0,Y0,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y==Y0 & nextAvailable(X0,Y0,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y==Y0 & nextAvailable(X0,Y0,left,_,_) <- !direction(X,Y,left).

+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y>Y0 & nextAvailable(X0,Y0,right,_,_) <- !direction(X,Y,right).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y>Y0 & nextAvailable(X0,Y0,down,_,_) <- !direction(X,Y,down).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y>Y0 & nextAvailable(X0,Y0,up,_,_) <- !direction(X,Y,up).
+!goTowards(X,Y): pos(X0,Y0) & X>X0 & Y>Y0 & nextAvailable(X0,Y0,left,_,_) <- !direction(X,Y,left).

+!direction(X,Y,D): pos(X0,Y0) & next(X0,Y0,D,X1,Y1)
	<- +visited(X0,Y0); move(D); +preMove(X1,Y1,D).
