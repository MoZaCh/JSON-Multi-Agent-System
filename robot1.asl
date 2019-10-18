/* Beliefs */
next(X0,Y0,up,X,Y) :- X=X0 & Y=Y0-1.
next(X0,Y0,down,X,Y) :- X=X0 & Y=Y0+1.
next(X0,Y0,left,X,Y) :- X=X0-1 & Y=Y0.
next(X0,Y0,right,X,Y) :- X=X0+1 & Y=Y0.

inGrid(X,Y) :- grid(Xg, Yg) & X>=0 & X<Xg & Y>=0 & Y<Yg.

nextAvailable(X0,Y0,D,X,Y) :- next(X0,Y0,D,X,Y) & inGrid(X,Y) & not obs(X,Y) & not visited(X,Y).

opposite(left,right).
opposite(right,left).
opposite(up,down).
opposite(down,up).


/* Goals */

!clean.

/* Plans */

+!clean : not garb(X,Y)
	<- ?pos(X0,Y0); ?nextAvailable(X0,Y0,D,X,Y); !tryGoTo(X,Y); !clean.	
//<- next(slot); !clean.

+!clean : garb(X,Y)
	<- ?pos(X0,Y0); !tryGoTo(X,Y); !tryPick; ?depot(Xd,Yd); !tryGoTo(Xd,Yd); drop(garb); !clean.
	
+!tryPick: pos(X,Y) & not garb(X,Y)
	<-true.
	
+!tryPick :pos(X,Y) & garb(X,Y)
	<-pick(garb) ; !tryPick.

+!tryGoTo(X,Y): true <- .abolish(visited(_,_)); .abolish(preMove(_,_,_)); !goTo(X,Y).
	
+!goTo(X,Y) : pos(X,Y)
	<-true.
	
+!goTo(X,Y) : obs(X,Y)
	<-true.
	
+!goTo(X,Y) : pos(X0,Y0) & nextAvailable(X0,Y0,D,X1,Y1)
	<- +visited(X0,Y0); move(D); +preMove(X1,Y1,D) ; !goTo(X,Y).
	
+!goTo(X,Y) : pos(X0,Y0) & preMove(X0,Y0,D1) & opposite(D1,D2)//nextAvailable(X0,Y0,D,X1,Y1)
	<- +visited(X0,Y0); move(D2); !goTo(X,Y).
//	 <-move_towards(X,Y); !tryToGo(X,Y).
	//<- move(D); !tryGoTo(X,Y).
	
+!goTo(X,Y) <- true.
