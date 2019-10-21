
/* beliefs */

/* rules */

block(X,Y) :- .member(X,[0,1,2,3,4,5,6]) 
			& .member(Y,[0,1,2,3,4,5,6]).
			
unvisited(X,Y) :- block(X,Y) 
				& not visited(X,Y) 
				& not obstacle(X,Y).

proxpos(X,Y) :- pos(X,Y) 
				| pos(X-1,Y) 
				| pos(X+1,Y) 
				| pos(X,Y-1) 
				| pos(X,Y+1).

last(X,[X]).
last(X,[_|L]) :- last(X,L).

/* plans */

!updatepercepts.
!clean.

@u01[atomic,priority(1)] 
+!updatepercepts : obs(X,Y) 
					& not obstacle(X,Y) 
					<- +obstacle(X,Y); 
					!updatepercepts.
					
@u02[atomic,priority(1)] 
+!updatepercepts : garb(X,Y) 
					& not garbage(X,Y) 
					<- +garbage(X,Y); 
					!updatepercepts.
					
@u03[atomic,priority(1)] 
+!updatepercepts : proxpos(X,Y) 
					& not garb(X,Y) 
					& garbage(X,Y) 
					<- -garbage(X,Y); 
					!updatepercepts.
					
@u04[atomic,priority(1)] 
+!updatepercepts : pos(X,Y) 
					& not visited(X,Y) 
					<- +visited(X,Y); 
					!updatepercepts.
					
@u05[atomic,priority(1)] 
+!updatepercepts : pos(X,Y) 
					& not visited(X-1,Y) 
					<- +visited(X-1,Y); 
					!updatepercepts.
					
@u06[atomic,priority(1)] 
+!updatepercepts : pos(X,Y) 
					& not visited(X+1,Y) 
					<- +visited(X+1,Y); 
					!updatepercepts.
					
@u07[atomic,priority(1)] 
+!updatepercepts : pos(X,Y) 
					& not visited(X,Y-1) 
					<- +visited(X,Y-1); 
					!updatepercepts.
					
@u08[atomic,priority(1)] 
+!updatepercepts : pos(X,Y) 
					& not visited(X,Y+1) 
					<- +visited(X,Y+1); 
					!updatepercepts.
					
@u09[atomic,priority(1)] 
+!updatepercepts <- true.

+!clean : pos(X1,Y1) 
			& garbage(X2,Y2) 
			& not cantvisit(X2,Y2) 
			<- !goTo(X2,Y2); 
			!try_pick(X2,Y2); 
			!goToDepot; 
			drop(garb); 
			!updatepercepts; 
			!clean .
			
+!clean : pos(X1,Y1) 
			& not garbage(X,Y) 
			& unvisited(X2,Y2) 
			& not cantvisit(X2,Y2) 
			<- !goTo(X2,Y2); 
			!clean.
			
+!clean <- -cantvisited(_,_).
-!clean <- !clean.

+!perform(X) <- X; !updatepercepts.

+!try_pick(X,Y) : pos(X,Y) & not garbage(X,Y) <- true.
+!try_pick(X,Y) : pos(X,Y) & garbage(X,Y) <- pick(garb); !updatepercepts; !try_pick(X,Y).

+!goToDepot : depot(X,Y) <- !goTo(X,Y).
-!goToDepot <- !goToDepot.


+!goTo(X2,Y2) : pos(X1,Y1) & helper.findPath(X1,Y1,X2,Y2,P) <- !followPath(P).
+!goTo(X2,Y2) <- +cantvisit(X2,Y2); .fail .

+!followPath([]) <- true.
+!followPath([loc(X,Y)|P]) : pos(X,Y) <- !followPath(P).
+!followPath([loc(X,Y)|P]) : pos(X-1,Y) & not obstacle(X,Y) <- move(right); !updatepercepts; !followPath(P).
+!followPath([loc(X,Y)|P]) : pos(X+1,Y) & not obstacle(X,Y) <- move(left); !updatepercepts; !followPath(P).
+!followPath([loc(X,Y)|P]) : pos(X,Y-1) & not obstacle(X,Y) <- move(down); !updatepercepts; !followPath(P).
+!followPath([loc(X,Y)|P]) : pos(X,Y+1) & not obstacle(X,Y) <- move(up); !updatepercepts; !followPath(P).
+!followPath(P) : last(loc(X,Y),P) <- !goTo(X,Y).

