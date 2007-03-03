//
//  AnimatingTab.h
//  WindowBlurTest
//
//  Created by StormSilver on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class CIFilter;
@class CIImage;

typedef enum {
	CGNone = 0,
	CGFade,
	CGZoom,
	CGReveal,
	CGSlide,
	CGWarpFade,
	CGSwap,
	CGCube,
	CGWarpSwitch,
	
    CICopyMachine,
    CIDisintegrate,
    CIDissolve,
    CIFlash,
    CIMod,
    CIPageCurl,
    CIRipple,
    CISwipe
} TransitionStyle;

@interface AnimatedTabView : NSTabView
{
    
    // Animation State
    CIFilter        *transitionFilter;      // the Core Image transition filter that will generate the animation frames
    CIImage         *inputShadingImage;     // an environment-map image that the transitionFilter may use in generating the transition effect
    CIImage         *inputMaskImage;        // a mask image that the transitionFilter may use in generating the transition effect
    NSRect          imageRect;              // the subrect of the AnimatingTabView where the animating image should be composited
    NSAnimation     *animation;             // the NSAnimation instance that will drive the transitionFilter's time input value
	float TRANSITION_DURATION;
}

- (void) transitionIn;
- (void) transitionOut;
@end
