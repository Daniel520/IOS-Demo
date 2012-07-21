//
//  Shader.fsh
//  CH03_SLQTSOR
//
//  Created by Michael Daley on 30/08/2009.
//  Copyright Michael Daley 2009. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
	gl_FragColor = colorVarying;
}
