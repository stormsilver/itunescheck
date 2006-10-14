#import "InfoController.h"


#define TIMER_INTERVAL (1.0 / 30.0)
#define NOT_RUNNING @"iTunes is not running."
#define NOT_PLAYING @"iTunes is not playing anything."



@implementation InfoController

#pragma mark -
#pragma mark Initialization

+ (id) sharedController
{
    static id sharedController;
    
    if (!sharedController)
    {
        sharedController = [[self alloc] init];
    }
    
    return sharedController;
}

+ (void) initialize
{
    //Expose some bindings
    [self exposeBinding:@"fadeInSpeed"];
    [self exposeBinding:@"fadeOutSpeed"];
    [self exposeBinding:@"delayTime"];
    [self exposeBinding:@"positionX"];
    [self exposeBinding:@"positionY"];
    [self exposeBinding:@"clickThroughWindow"];
}

- (id) init
{
    _fadeTimer = nil;
    _previousTrackInfo = nil;
    _displayPluginsController = [[DisplayPluginsController alloc] init];
    _scriptController = [ScriptController sharedController];
    
    NSUserDefaultsController *susd = [NSUserDefaultsController sharedUserDefaultsController];
    [self bind:@"fadeInSpeed" toObject:susd withKeyPath:@"values.fadeInSpeed" options:nil];
    [self bind:@"fadeOutSpeed" toObject:susd withKeyPath:@"values.fadeOutSpeed" options:nil];
    [self bind:@"clickThroughWindow" toObject:susd withKeyPath:@"values.clickThroughWindow" options:nil];
    [self bind:@"delayTime" toObject:susd withKeyPath:@"values.delayTime" options:nil];
    [self bind:@"positionX" toObject:susd withKeyPath:@"values.NSWindow Frame positioner" options:nil];
    [self bind:@"positionY" toObject:susd withKeyPath:@"values.NSWindow Frame positioner" options:nil];
    
    _panel = [[[NSPanel alloc] initWithContentRect:NSMakeRect(_positionX, _positionY, 40., 40.)
                                         styleMask:NSBorderlessWindowMask
                                           backing:NSBackingStoreBuffered defer:NO] autorelease];
    [_panel setBecomesKeyOnlyIfNeeded:YES];
    [_panel setWorksWhenModal:YES];
    [_panel setHidesOnDeactivate:NO];
    [_panel setBackgroundColor:[NSColor clearColor]];
    [_panel setLevel:NSStatusWindowLevel];
    [_panel setAlphaValue:0.];
    [_panel setOpaque:NO];
    [_panel setHasShadow:NO];
    [_panel setCanHide:NO];
    [_panel setReleasedWhenClosed:YES];
    [_panel setDelegate:self];
    
    _roundedView = [[RoundedView alloc] init];
    [_panel setContentView:_roundedView];
    
    //Set some prettiness factors
    [_roundedView setRadius:20.0];
    
    //Bind various values
    [_roundedView bind:@"backgroundColor" toObject:susd withKeyPath:@"values.infoWindowBackgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    
    return (self = [super initWithWindow:_panel]);
}






#pragma mark -
#pragma mark Bindings
//These methods are necessary to implement bindings
- (void) setFadeInSpeed:(float)fade
{
    _fadeInSpeed = fade;
}

- (float) fadeInSpeed
{
    return _fadeInSpeed;
}

- (void) setFadeOutSpeed:(float)fade
{
    _fadeOutSpeed = fade;
}

- (float) fadeOutSpeed
{
    return _fadeOutSpeed;
}

- (void) setDelayTime:(float)time
{
    _delayTime = time;
}

- (float) delayTime
{
    return _delayTime;
}

- (void) setPositionX:(NSString *)x
{
    _positionX = NSMinX(NSRectFromString(x));
}

- (float) positionX
{
    return _positionX;
}

- (void) setPositionY:(NSString *)y
{
    _positionY = NSMinY(NSRectFromString(y));
}

- (float) positionY
{
    return _positionY;
}

- (void) setClickThroughWindow:(BOOL)click
{
    [_panel setIgnoresMouseEvents:click];
}
- (BOOL) clickThroughWindow
{
    return [_panel ignoresMouseEvents];
}






#pragma mark -
#pragma mark Display
- (void)_bezelClicked:(id)sender
{
	[self startFadeOut];
}

- (void) goAway
{
    if ([_panel isVisible])
    {
        _fadeOut = YES;
        [self startFadeOut];
    }
}

- (void) _stopTimer
{
	[_fadeTimer invalidate];
	[_fadeTimer release];
	_fadeTimer = nil;
}
- (void)_waitBeforeFadeOut
{
    [self _stopTimer];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"animateWindows"])
    {
        InfoView *view = [[_roundedView subviews] lastObject];
        [_panel setFrame:[view positionSubviewsAtPoint:NSMakePoint(_positionX, _positionY)] display:YES animate:YES];
        [view setHidden:NO];
    }
    
    _fadeTimer = [[NSTimer scheduledTimerWithTimeInterval:_delayTime
                                                   target:self
                                                 selector:@selector( startFadeOut )
                                                 userInfo:nil
                                                  repeats:NO] retain];
}

- (void)_fadeWindowIn:(NSTimer *)timer
{
    NSWindow *myWindow = [self window];
	float alpha = [myWindow alphaValue];
	if ( alpha < 1. )
    {
        [myWindow setAlphaValue:( alpha + _fadeInSpeed)];
	} else {
        [self _waitBeforeFadeOut];
	}
    
}

- (void)_fadeWindowOut:(NSTimer *)timer
{
    NSWindow *myWindow = [self window];
	float alpha = [myWindow alphaValue];
	if ( alpha > 0. )
    {
		[myWindow setAlphaValue:( alpha - _fadeOutSpeed)];
	} else {
		[self _stopTimer];
		[self close]; // close our window
		[self autorelease]; // we retained when we faded in
	}
}

- (void) startFadeIn
{
    [self retain]; // release after fade out
    [self showWindow:nil];
	[self _stopTimer];
    
    BOOL animate = [[NSUserDefaults standardUserDefaults] boolForKey:@"animateWindows"];
    
    if (animate)
    {
        if (![_panel isVisible])
        {
            [_panel setFrame:NSMakeRect(_positionX, _positionY, 50.0, 50.0) display:YES];
        }
    }
    else
    {
        InfoView *view = [[_roundedView subviews] lastObject];
        [_panel setFrame:[view positionSubviewsAtPoint:NSMakePoint(_positionX, _positionY)] display:YES animate:YES];
        [view setHidden:NO];
    }
    _fadeTimer = [[NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                   target:self
                                                 selector:@selector( _fadeWindowIn: )
                                                 userInfo:nil
                                                  repeats:YES] retain];
}

- (void) startFadeOut
{
	[self _stopTimer];
    if (_fadeOut)
    {
        BOOL animate = [[NSUserDefaults standardUserDefaults] boolForKey:@"animateWindows"];
        if (animate)
        {
            InfoView *view = [[_roundedView subviews] lastObject];
            [view setHidden:YES];
        }
        _fadeTimer = [[NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                       target:self
                                                     selector:@selector( _fadeWindowOut: )
                                                     userInfo:nil
                                                      repeats:YES] retain];
        if (animate)
        {
            NSRect panelFrame = [_panel frame];
            [_panel setFrame:NSMakeRect(panelFrame.origin.x, panelFrame.origin.y, 50., 50.) display:YES animate:YES];
        }
    }
}

- (void) displayFromNotification:(NSNotification *)aNotification
{
    NSDictionary *trackInfo = [aNotification userInfo];
    if (([trackInfo objectForKey:@"Location"] != nil) && [[trackInfo objectForKey:@"Player State"] isEqual:@"Playing"] && ![[trackInfo objectForKey:@"Location"] isEqual:[_previousTrackInfo objectForKey:@"Location"]])
    {
        [self display];
    }
    else if (![[trackInfo objectForKey:@"Player State"] isEqual:[_previousTrackInfo objectForKey:@"Player State"]])
    {
        int action = [[NSUserDefaults standardUserDefaults] integerForKey:@"keyPressAction"];
        if ((action == 2) || (action == 3))
        {
            [self display];
        }
    }
    [_previousTrackInfo release];
    _previousTrackInfo = [trackInfo retain];
}

- (void) display
{
    //NSLog(@"[InfoController display]");
    int iTunesState = [_scriptController iTunesState];
    BOOL visible = [_panel isVisible];
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"keyPressAction"])
    {
        // Song Change
        case 0:
        // Key Press
        case 1:
            switch (iTunesState)
            {
                // Not Running
                case 0:
                    [self showMessage:NOT_RUNNING withLaunchButton:YES andFade:YES];
                    break;
                    
                    // Not Playing
                case 1:
                    [self showMessage:NOT_PLAYING];
                    break;
                    
                    // Playing
                case 2:
                    _fadeOut = YES;
                    [self updateTrackInfoWithView:[self trackInfo]];
                    [self startFadeIn];
                    break;
            }
            break;
            
        // Always
        case 2:
            switch (iTunesState)
            {
                case 0:
                    _fadeOut = NO;
                    [self showMessage:NOT_RUNNING withLaunchButton:YES andFade:NO];
                    [self startFadeIn];
                    break;
                    
                case 1:
                    _fadeOut = NO;
                    [self showMessage:NOT_RUNNING withLaunchButton:NO andFade:NO];
                    [self startFadeIn];
                    break;
                    
                case 2:
                    _fadeOut = NO;
                    [self updateTrackInfoWithView:[self trackInfo]];
                    [self startFadeIn];
                    break;
            }
            break;
            
        // While Playing
        case 3:
            switch (iTunesState)
            {
                case 0:
                    _fadeOut = YES;
                    if (visible)
                    {
                        [self showMessage:NOT_RUNNING withLaunchButton:YES andFade:NO];
                        [self _waitBeforeFadeOut];
                    }
                        else
                        {
                            [self showMessage:NOT_RUNNING];
                        }
                        break;
                    
                case 1:
                    _fadeOut = YES;
                    if (visible)
                    {
                        [self showMessage:NOT_PLAYING withLaunchButton:NO andFade:NO];
                        [self _waitBeforeFadeOut];
                    }
                        else
                        {
                            [self showMessage:NOT_PLAYING];
                        }
                        break;
                    
                case 2:
                    _fadeOut = NO;
                    [self updateTrackInfoWithView:[self trackInfo]];
                    [self startFadeIn];
                    break;
            }
            break;
    }
}

- (void) showMessage:(NSString *)theMessage
{
    [self showMessage:theMessage withLaunchButton:NO andFade:YES];
}

- (void) showMessage:(NSString *)theMessage withLaunchButton:(BOOL)launch andFade:(BOOL)fade
{
    InfoView *infoView = [[[InfoView alloc] init] autorelease];
    NSMutableAttributedString *passThru = [[NSMutableAttributedString alloc] initWithString:theMessage];
    NSRange range = NSMakeRange(0, [passThru length]);
    [passThru addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:20] range:range];
    [passThru addAttribute:NSForegroundColorAttributeName 
                     value:(NSColor *)[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"textColor"]] 
                     range:range];
    [infoView setText:passThru];
    [infoView setLaunchButton:launch];
    [infoView setHidden:[[NSUserDefaults standardUserDefaults] boolForKey:@"animateWindows"]];
    
    [self updateTrackInfoWithView:infoView];
    
    if (fade)
    {
        _fadeOut = YES;
        [self startFadeIn];
    }
}

- (void) updateTrackInfoWithView:(InfoView *)theInfoView
{
    [[[_roundedView subviews] lastObject] removeFromSuperview];
    [_panel display];
    [_roundedView addSubview:theInfoView];
}



- (InfoView *) trackInfo
{
    //NSLog(@"getting trackInfo...");
    InfoView *infoView = [[[InfoView alloc] init] autorelease];
    NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
    
    //First we'll test to make sure iTunes is running.
    if ([_scriptController iTunesPlaying])
    {
        NSMutableAttributedString *info = [[_displayPluginsController retrieveInfo] retain];
        //push the text color onto the string
        //[info addAttribute:NSForegroundColorAttributeName value:(NSColor *)[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"textColor"]] range:NSMakeRange(0, [info length])];
        [infoView setText:info];
        
        //Alright, we've got the info, let's get the album cover art, if we're supposed to
        if ([usd boolForKey:@"showAlbumArt"])
        {
            float imagePrefSize = [usd integerForKey:@"albumArtSize"];
            NSAppleEventDescriptor *rval;
            if ([usd boolForKey:@"findFileArtwork"])
            {
                rval = [_scriptController doAppleScript:@"artwork_search"];
            }
            else
            {
                rval = [_scriptController doAppleScript:@"artwork_nosearch"];
            }
            if (!rval)
            {
                //NSLog(@"error");
            }
            else
            {
                //Create an image object with the returned data
                NSImage *image = [[NSImage alloc] initWithData:[rval data]];
                if ([image isValid])
                {
                    //NSLog(@"image valid");
                    NSSize imageSize = [image size];
                    if ( imageSize.width > imagePrefSize || imageSize.height > imagePrefSize )
                    {
                        //Scale the image appropiately. This uses a nice high-quality scaling technique.
                        //Much better than just telling the image to resize itself!
                        float newWidth;
                        float newHeight;
                        if (imageSize.width > imageSize.height)
                        {
                            newWidth = imagePrefSize;
                            newHeight = imagePrefSize / imageSize.width * imageSize.height;
                        }
                        else if (imageSize.width < imageSize.height)
                        {
                            newWidth = imagePrefSize / imageSize.height * imageSize.width;
                            newHeight = imagePrefSize;
                        }
                        else
                        {
                            newWidth = imagePrefSize;
                            newHeight = imagePrefSize;
                        }
                        
                        NSRect newBounds = NSMakeRect(0.0, 0.0, newWidth, newHeight);
                        NSImageRep *sourceImageRep = [image bestRepresentationForDevice:nil];
                        [image release];
                        image = [[NSImage alloc] initWithSize:NSMakeSize(newWidth, newHeight)];
                        [image lockFocus];
                        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
                        [sourceImageRep drawInRect:newBounds];
                        [image unlockFocus];
                    }
                    [infoView setGraphic:image];
                }
                [image release];
            }
        }
        
        [infoView setStreaming:![[_scriptController doAppleScript:@"isStreaming"] booleanValue]];
        [infoView setTarget:self];
        [infoView setAction:@selector(_bezelClicked:)];
        [infoView setHidden:[usd boolForKey:@"animateWindows"]];
    }
    
    //NSLog(@"...done");
    return infoView;
}


@end
