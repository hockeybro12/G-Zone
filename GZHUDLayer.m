//
//  GZHUDLayer.m
//  GZone
//
//  Created by Nikhil Mehta on 10/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GZHUDLayer.h"

@implementation GZHUDLayer

-(id)init {
    
    if (self = [super init]) {
        [self addDisplay];
    }
    return self;
}

-(void)addDisplay {
    
   // CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    
    //add distance text
    CCLabelTTF *dist = [CCLabelTTF labelWithString:@"Score:" fontName:@"Verdana" fontSize:16];
    [dist setAnchorPoint:ccp(0, 0.5)];
    [dist setPosition:ccp(10, 305)];
    dist.color = [CCColor colorWithCcColor3b:ccc3(225, 215, 0)];
    [self addChild:dist];
    
    //add counter
    Distancelabel = [CCLabelTTF labelWithString:@"0.0" fontName:@"Verdana" fontSize:16];
    [Distancelabel setAnchorPoint:ccp(0, 0.5)];
    [Distancelabel setPosition:ccp(120, 305)];
    Distancelabel.color = [CCColor colorWithCcColor3b:ccc3(225, 215, 0)];
    [self addChild:Distancelabel];

}

-(void)changeDistanceTo:(float)newDistance {
    
    NSString *newValue = [NSString stringWithFormat:@"%0.f", newDistance];
    
    [Distancelabel setString:newValue];
        
    
}


@end
