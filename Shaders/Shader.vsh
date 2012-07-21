//
//  Shader.vsh
//  CH03_SLQTSOR
//
//  Created by Michael Daley on 30/08/2009.
//  Copyright Michael Daley 2009. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
	gl_Position = position;
	gl_Position.y += sin(translate) / 2.0;
	
	colorVarying = color;
}
