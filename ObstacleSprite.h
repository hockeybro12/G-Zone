//
//  ObstacleSprite.h
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface ObstacleSprite : CCSprite {
    
    CGRect collisionSensor;
}

@property (nonatomic, assign) CGRect collisionSensor;

@end
