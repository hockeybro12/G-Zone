//
//  GZGameData.h
//  GZone
//
//  Created by Nikhil Mehta on 11/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameOverLayer.h"

@interface GZGameData : NSObject <NSCoding> {
    
    NSInteger newScore;
    
    NSInteger newAdvertisementNumber;
    
    NSInteger newMuteNumber;
    
}

@property (assign, nonatomic) NSInteger newScore;
@property (assign, nonatomic) NSInteger newAdvertisementNumber;
@property (assign, nonatomic) NSInteger newMuteNumber;


//-(void)giveScore:(NSInteger)score;

-(void)setMessage:(NSString *)message scores:(NSInteger)score;

+(instancetype)sharedGameData;

-(void)save;



@end
