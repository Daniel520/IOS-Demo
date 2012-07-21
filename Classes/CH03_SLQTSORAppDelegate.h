//
//  CH03_SLQTSORAppDelegate.h
//  CH03_SLQTSOR
//
//  Created by Michael Daley on 30/08/2009.
//  Copyright Michael Daley 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface CH03_SLQTSORAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end

