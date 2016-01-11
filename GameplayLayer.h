//
//  GameplayLayer.h
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GZDefinitions.h"
#import "ObstacleSprite.h"
#import "PlanetSprite.h"
#import "SatelliteSprite.h"
#import "GZHUDLayer.h"
#import "cocos2d.h"
#import "GameOverLayer.h"
#import <Foundation/Foundation.h>

@interface GameplayLayer : CCNode {
    
    BOOL gameHasBegan;
    
    BOOL isGameOver;
    
    BOOL alreadyFinishedGameOver;
    
    BOOL stateChanged;
    
    CGSize size;
    
    CCNode *runnerSheet1;
        
    NSMutableArray *obstacleSpritesCreated;
    NSMutableArray *obstacleSpritesDestroyed;
    
    PlanetSprite *planet;
    
    SatelliteSprite *satellite;
    
    GZHUDLayer *hudLayer;
    
    CCTime timeToRotate;
    
    float angle;
    
    float distanceTravelled;
    float maxTileX;
    float scoreSpeed;
    
    float moveInOutSpeed;
    
    NSInteger radiusSpeed;
    
    BOOL stopUpdatingGameOver;
    
    BOOL soundIsActive;
    
    NSInteger muteButtonValue;
    
    BOOL alreadyCalledUpdate;
    BOOL alreadyCalledSecondUpdate;
    
    
}

@property (nonatomic, assign) BOOL isGameOver;
@property (nonatomic, assign) BOOL gameHasBegun;
@property (nonatomic, assign) BOOL stopUpdatingGameOver;
@property (nonatomic, assign) BOOL stateChanged;
@property (nonatomic, assign) BOOL alreadyFinishedGameOver;
@property (nonatomic, assign) BOOL soundIsActive;
@property (nonatomic, assign) BOOL alreadyCalledUpdate;
@property (nonatomic, assign) BOOL alreadyCalledSecondUpdate;



@end
