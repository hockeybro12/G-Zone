//
//  KamcordRecorder+Metal.h
//  Kamcord
//
//  Created by Sam Green on 10/15/14.
//  Copyright (c) 2014 Kamcord. All rights reserved.
//

#import "KamcordRecorder.h"

#ifdef __arm64__
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

@interface KamcordRecorder ()

/*
 *
 * Call once when the layer and device are created.
 *
 */
+ (void)configureLayer:(CAMetalLayer *)layer
            fromDevice:(id <MTLDevice>)device;

/*
 *
 * Call every frame once you get the new drawable.
 *
 */
+ (void)setCurrentDrawable:(id <CAMetalDrawable>)drawable;

/*
 *
 * Call every frame after setCurrentDrawable to record that frame.
 *
 */
+ (void)addMetalCommands:(id <MTLCommandBuffer>)commandBuffer;

@end

#endif
