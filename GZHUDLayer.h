//
//  GZHUDLayer.h
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import <Foundation/Foundation.h>

@interface GZHUDLayer : CCNode {

    CCLabelTTF *Distancelabel;
    
}

-(void)changeDistanceTo:(float)newDistance;

//-(void)showGameOver:(NSString*)msg;

@end
