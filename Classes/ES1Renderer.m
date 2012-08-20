//
//  ES1Renderer.m
//  CH03_SLQTSOR
//
//  Created by Michael Daley on 30/08/2009.
//  Copyright Michael Daley 2009. All rights reserved.
//

#import "ES1Renderer.h"
#import "Global.h"
#import "GameController.h"

@interface ES1Renderer (Private)
- (void)initOpenGL;
@end

@implementation ES1Renderer

// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            [self release];
            return nil;
        }
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
        
        // Grab a reference to the shared game controller.
        sharedGameController = [GameController sharedGameController];
	}
	
	return self;
}

- (void) render {
    
    // Clear the color buffer which clears the screen
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Ask the game controller to render the current scene
    [sharedGameController renderCurrentScene];
    
    // Present the renderbuffer to the screen
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    // Initialize OpenGL now that the necessary buffers have been created and bound
    [self initOpenGL];
    
    return YES;
}

- (void) dealloc
{
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}

	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
	
	[super dealloc];
}

@end

#pragma mark -
#pragma mark Private implementation

@implementation ES1Renderer (Private)

- (void)initOpenGL
{
    SLQLOG(@"INFO - ES1Renderer: Initializing OpenGL");
    
    // Switch to GL_PROJECTION matrix mode and reset the current matrix with the identity martix
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    glOrthof(0, backingWidth, 0, backingHeight, -1, 1);
    
    // Set the viewport
    glViewport(0, 0, backingWidth, backingHeight);
    
    SLQLOG(@"INFO - ES1Renderer: Setting glOrthof to width=%d and height=%d", backingWidth, backingHeight);
    
    
    // Swtich to GL_MODELVIEW so we can now draw our objects
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    // Set the color to use when clearing the screen with glClear
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    // We just create a 2D game, so no need to set the depth testing on
    glDisable(GL_DEPTH_TEST);
    
    // Enable the OpenGL states we are going to be using when rendering
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
}

@end
