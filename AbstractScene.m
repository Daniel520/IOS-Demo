//
//  AbsractScene.m
//  CH03_SLQTSOR
//
//  Created by Daniel yu on 12-8-20.
//  Copyright (c) 2012年 Michael Daley. All rights reserved.
//

#import "AbstractScene.h"

@implementation AbstractScene

@synthesize sceneState;
@synthesize sceneAlpha;

- (void)updateWithDelta:(float)aDelta {}
- (void)renderScene {}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {}
- (void)updateWithAccelerometer:(UIAcceleration *)aAcceleration {}

@end
