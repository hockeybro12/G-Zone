//
//  GZDefinitions.h
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//


typedef enum {
    kSatelliteConstant = 1,
    kSatelliteMovingIn,
    kSatelliteMovingOut
}SatelliteState;


typedef enum {
    kObstacleExists = 1,
    kObstacleDestroyed
}ObstacleState;