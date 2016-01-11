//
//  SatelliteSprite.m
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SatelliteSprite.h"
#import "GameplayLayer.h"

@implementation SatelliteSprite
@synthesize collisionSensor;
@synthesize state = _state;
@synthesize pf;

+(id)spriteWithSpriteFrame:(CCSpriteFrame*)spriteFrame
{
    return [[self alloc] initWithSpriteFrame:spriteFrame];
}


-(void)stateChangeTo:(SatelliteState)newState {
    
    
    if (newState == _state) {

        return;
    }
    
    [self stopAllActions];
    
    switch (newState) {
            
        case kSatelliteConstant:
            [self playConstantAnim];
            break;
            
        case kSatelliteMovingIn:
            [self playSatelliteMovingInAnim];
            break;
            
        case kSatelliteMovingOut:
            [self playSatelliteMovingOutAnim];
            break;
        
    }
    
    _state = newState;
    
// CCLOG(@"%u", _state);


}

-(void)defineSensors {
    
    collisionSensor = CGRectMake(self.boundingBox.origin.x + 7, self.boundingBox.origin.y - 7, self.boundingBox.size.width - 7, self.boundingBox.size.height - 7);
}


-(void)setPosition:(CGPoint)position {
    
    [super setPosition:position];
    
    [self defineSensors];
    
    
}

-(void)playConstantAnim {
    
    CCActionCallBlock *change = [CCActionCallBlock actionWithBlock:^{
        [self stateChangeTo:kSatelliteConstant];
    }];
    CCActionSequence *doThat = [CCActionSequence actions:change, nil];
    
    [self runAction:doThat];
}

-(void)playSatelliteMovingInAnim {
    CCActionCallBlock *change = [CCActionCallBlock actionWithBlock:^{
        [self stateChangeTo:kSatelliteMovingIn];
    }];
    CCActionSequence *doThat = [CCActionSequence actions:change, nil];
    
    [self runAction:doThat];
    
}

-(void)playSatelliteMovingOutAnim {
    
    CCActionCallBlock *change = [CCActionCallBlock actionWithBlock:^{
        [self stateChangeTo:kSatelliteMovingOut];
    }];
    CCActionSequence *doThat = [CCActionSequence actions:change, nil];
    
    [self runAction:doThat];
}



@end
