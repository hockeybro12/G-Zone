//
//  SatelliteSprite.h
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "GZDefinitions.h"
#import "cocos2d.h"
#import <Foundation/Foundation.h>

@class GameplayLayer;

@interface SatelliteSprite : CCSprite {
    
    SatelliteState _state;
    
    CGRect collisionSensor;
}

@property (nonatomic, assign) CGRect collisionSensor;

@property (nonatomic, readonly) SatelliteState state;

@property (nonatomic, assign) GameplayLayer *pf;


-(void)stateChangeTo:(SatelliteState)newState;



@end
