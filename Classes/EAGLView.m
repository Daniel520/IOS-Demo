//
//  EAGLView.m
//  CH03_SLQTSOR
//
//  Created by Michael Daley on 30/08/2009.
//  Copyright Michael Daley 2009. All rights reserved.
//

#import "EAGLView.h"
#import "ES1Renderer.h"
#import "GameController.h"

@implementation EAGLView

@synthesize animating;
//developer need to implement the getter and setter method for animationFrameInterval by yourself.
@dynamic animationFrameInterval;

// You must implement this method
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id) initWithCoder:(NSCoder*)coder {    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        //set the kEAGLDrawablePropertyRetainedBacking = 0 and kEAGLDrawablePropertyColorForma = 
        //kEAGLColorFormatRGBA8 for drawableProperties
        //kEAGLDrawablePropertyRetainedBacking is config if the drawable surface still retain it's content after display, defualt is a NSNumber contain a BOOL value FALSE!.
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
        
        renderer = [[ES1Renderer alloc] init];
        
        if (!renderer)
        {
            [self release];
            return nil;
        }
        
        
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
			displayLinkSupported = TRUE;
        
        // Grab an instance of the shared game controller
        sharedGameController = [GameController sharedGameController];
    }
	
    return self;
}

#pragma mark GameLoop method

#define MAXIMUM_FRAME_RATE 45
#define MINIMUM_FRAME_RATE 15
#define UPDATE_INTERVAL (1.0 / MAXIMUM_FRAME_RATE)
#define MAX_CYCLES_PER_FRAME (MAXIMUM_FRAME_RATE / MINIMUM_FRAME_RATE)

// MAXIMUM_FRAME_RATE constant determines the frequency of the update cycles
// MINIMUM_FRAME_RATE constant determines how many time updated per second
// UPDATE_INTERVAL constant determines how many cycles in one second
// MAX_CYCLES_PER_FRAME constant determines how many frame can be updated in one cycles
- (void)gameLoop
{
    static double lastFrameTime = 0.0f;
    static double cyclesLeftOver = 0.0f;
    double currentTime;
    double updateIteration;
    
    // Apple advises to use CACurrentMediaTime() as CFAsoluteTimeGetCurrent is synced with the mobile
    // network time and so could change causing hiccps.
    currentTime = CACurrentMediaTime();
    updateIteration = ((currentTime - lastFrameTime) + cyclesLeftOver);
    
    if (updateIteration > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        updateIteration = MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL;
    }
        
    while(updateIteration >= UPDATE_INTERVAL){
        updateIteration -= UPDATE_INTERVAL;
        
        [sharedGameController updateCurrentSceneWithDelta:UPDATE_INTERVAL];
    }
    
    cyclesLeftOver = updateIteration;
    lastFrameTime = currentTime;
    
    // Render the scene
    [self drawView:nil];
}


- (void) drawView:(id)sender
{
    [renderer render];
    
}

- (void) layoutSubviews
{
	[renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) startAnimation
{
	if (!animating)
	{
		if (displayLinkSupported)
		{
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.

			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(gameLoop)];
			[displayLink setFrameInterval:animationFrameInterval];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(gameLoop) userInfo:nil repeats:TRUE];
		
		animating = TRUE;
	}
}

- (void)stopAnimation
{
	if (animating)
	{
		if (displayLinkSupported)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
		
		animating = FALSE;
	}
}

- (void) dealloc
{
    [renderer release];
	
    [super dealloc];
}

@end
