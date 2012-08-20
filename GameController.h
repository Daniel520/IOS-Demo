//
//  GameController.h
//  CH03_SLQTSOR
//
//  Created by Daniel yu on 12-8-20.
//  Copyright (c) 2012年 Michael Daley. All rights reserved.
//
#import <OpenGLES/ES1/gl.h>
#import "SynthesizeSingleton.h"

@class AbstractScene;

@interface GameController : NSObject <UIAccelerometerDelegate> {
    // Dictionary of the different game scenes
    NSDictionary *gameScenes;
    // Current scene
    AbstractScene *currentScene;
}  

@property (nonatomic, retain) AbstractScene *currentScene;

// Class method to return an instance of GameController. This is needed as this
// class is a singleton class.
+ (GameController *)sharedGameController;

// Update the logic within the current scene.
- (void)updateCurrentSceneWithDelta:(float)aDelta;

// Reneder the current scene.
- (void)renderCurrentScene;

@end
