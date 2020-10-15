function [vxOut, vyOut] = RotateQuiver(vx, vy, thetaInDegrees, thetaInRadians)
vxOut = imrotate(vx, thetaInDegrees)*cos(thetaInRadians) - imrotate(-vy, thetaInDegrees)*sin(thetaInRadians);
vyOut = -(imrotate(vx, thetaInDegrees)*sin(thetaInRadians) + imrotate(-vy, thetaInDegrees)*cos(thetaInRadians));