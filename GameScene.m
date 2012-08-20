//
//  GameScene.m
//  CH03_SLQTSOR
//
//  Created by Daniel yu on 12-8-21.
//  Copyright (c) 2012年 Michael Daley. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (void)updateWithDelta:(float)aDelta
{
    transY += 0.075f;
}

- (void)renderScene
{
    static const GLfloat squareVertices[] = {
        50 , 50,
        250, 50,
        50 , 250,
        250, 250,
    };
    
    static const GLubyte squareColors[] = {
        255,   0,   0, 255,
        255,   0,   0, 255,
        255, 255,   0,   0,
        255,   0,   0, 255,
    };
    
    glTranslatef(0.0f, (GLfloat)(sinf(transY) / 0.15f), 0.0f);
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
