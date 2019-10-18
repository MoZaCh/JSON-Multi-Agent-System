//Goal

checkGrid(X,Y) :- grid(Xg,Yg) & X>=0 & X<Xg & Y>=0 & Y<Yg.

!move(6,1).



//Plan

//H
+!move(X,Y) : pos(RobotX,RobotY) & RobotY > Y & (obs(RobotX, RobotY+1) & checkGrid(RobotX, RobotY -1) | myDownBlocked) <- move(up); .print("Up1"); +myDownBlocked; -myLeftBlocked; -myRightBlocked; !move(X,Y).


+!move(X,Y) : pos(RobotX,RobotY) & RobotY > Y & (obs(RobotX, RobotY-1) & checkGrid(RobotX +1, RobotY) | myLeftBLocked) <- move(right); .print("Right1"); +myLeftBlocked; !move(X,Y).
//grid(XG, YG) & (RobotX +1) >= XG) | myRightBlocked)  <- -myLeftBlocked; move(left); +myRightBlocked; !move(X,Y).


+!move(X,Y) : pos(RobotX,RobotY) & RobotY > Y & (obs(RobotX, RobotY-1) & checkGrid(RobotX -1, RobotY) | myRightBlocked) <- move(left); .print("Left1"); +myRightBlocked; !move(X,Y).

+!move(X,Y) : pos(RobotX,RobotY) & RobotX < X & (obs(RobotX+1,RobotY) & checkGrid(RobotX, RobotY-1)) <- move(up); .print("Up1"); !move(X,Y).



//grid(XG, YG) & (RobotX -1) < 0) | myLeftBlocked)  <- move(right); +myLeftBlocked; !move(X,Y).

//+!move(X,Y) : pos(RobotX,RobotY) & RobotY < Y & (obs(RobotX, RobotY-1) & checkGrid(RobotX, RobotY +1)| myUpBlocked) <- move(down); .print("Donw1"); +myUpBlocked; !move(X,Y).

//V
//+!move(X,Y) : pos(RobotX,RobotY) & RobotY < Y & ((obs(RobotX, RobotY+1) & grid(XG, YG) & (RobotX -1) < 0) | myDownBlocked) <-move(up); +myDownBlocked; !move(X,Y).
//+!move(X,Y) : pos(RobotX,RobotY) & RobotX <= X & (obv(RobotX+1, RobotY) & grid(XG,YG) & (RobotY -1) > 0) <- move(up); !move(X,Y).


////////////////////
+!move(X,Y) : pos(RobotX,RobotY) & RobotX > X & not obs(RobotX-1, RobotY) & checkGrid(RobotX-1,RobotY) <- move(left); .print("Left2"); !move(X,Y).
+!move(X,Y) : pos(RobotX,RobotY) & RobotX < X & not obs(RobotX+1, RobotY) & checkGrid(RobotX+1,RobotY) <- move(right); .print("Right2"); !move(X,Y).
+!move(X,Y) : pos(RobotX,RobotY) & RobotY > Y & not obs(RobotX, RobotY-1) & checkGrid(RobotX,RobotY-1) <- move(up); .print("Up2"); !move(X,Y).
+!move(X,Y) : pos(RobotX,RobotY) & RobotY < Y & not obs(RobotX, RobotY+1) & checkGrid(RobotX,RobotY+1) <- move(down); .print("Down2") !move(X,Y).







//+!move(X,Y)

+!move(X,Y) : pos(X,Y) <- .print(egg).

