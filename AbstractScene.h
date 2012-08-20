//
//  AbsractScene.h
//  CH03_SLQTSOR
//
//  Created by Daniel yu on 12-8-20.
//  Copyright (c) 2012年 Michael Daley. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface AbstractScene : NSObject {
    CGRect screenBounds;
    uint sceneState;
    GLfloat sceneAlpha;
    NSString *nextSceneKey;
    float sceneFadeSpeed;
}

#pragma mark - 
#pragma mark Properties

// This property allows for the scenes state to be altered
@property (nonatomic, assign) uint sceneState;

// This property allows for the scenes alpha to be changed.
@property (nonatomic, assign) GLfloat sceneAlpha; 

#pragma mark -
#pragma mark Methods

// Selector to update the scenes logic using |aDelta| which is passed in from the game loop
- (void)updateWithDelta:(float)aDelta;

// Selector which render the scene
- (void)renderScene;

// Selector that enables a touchesBegan events location to be passed into a scene.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event view:(UIView*)aView;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event view:(UIView*)aView;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event view:(UIView*)aView;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent *)event view:(UIView*)aView;

// Selector which enables accelerometer data to be passed into the scene.
- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration;

@end
