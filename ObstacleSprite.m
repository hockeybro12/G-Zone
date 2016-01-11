//
//  ObstacleSprite.m
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ObstacleSprite.h"

@implementation ObstacleSprite
@synthesize collisionSensor;

-(void)defineSensors {
    
    collisionSensor = CGRectMake(self.boundingBox.origin.x + 8, self.boundingBox.origin.y - 8, self.boundingBox.size.width - 8, self.boundingBox.size.height - 8);
}


-(void)setPosition:(CGPoint)position {
    //Override so we can kepp sensors together
    
    [super setPosition:position];
    
    [self defineSensors];
    
}

@end
