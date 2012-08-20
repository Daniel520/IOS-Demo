//
//  GameController.m
//  CH03_SLQTSOR
//
//  Created by Daniel yu on 12-8-20.
//  Copyright (c) 2012年 Michael Daley. All rights reserved.
//

#import "GameController.h"
#import "GameScene.h"
#import "Common.h"

@interface GameController (Private)

// Initialize the game
- (void)initGame;
@end

#pragma mark -
#pragma mark Public implementation
@implementation GameController

@synthesize currentScene;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(GameController)

- (void)dealloc
{
    [gameScenes release];
    [super dealloc];
}


- (id)init 
{
    if (self = [super init]) {
        // Initialize the game
        currentScene = nil;
        [self initGame];
    }
    
    return self;
}

- (void)updateCurrentSceneWithDelta:(float)aDelta
{
    [currentScene updateWithDelta:aDelta];
}

- (void)renderCurrentScene
{
    [currentScene renderScene];
}

#pragma mark -
#pragma mark Accelerometer

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
}
@end

#pragma mark -
#pragma mark Private implementation

@implementation GameController (Private)

- (void) initGame
{
    SLQLOG(@"INFO - GameController: Starting game initialization.");
    
    // Initialize game scenes
    gameScenes = [[NSMutableDictionary alloc] initWithCapacity:5];
    AbstractScene *scene = [[GameScene alloc] init];
    [gameScenes setValue:scene forKey:@"game"];
    [scene release];
    
    // Set the initial game scene
    currentScene = [gameScenes objectForKey:@"game"];
    
    SLQLOG(@"INFO - GameController: Finished game initialization.")
}

@end
