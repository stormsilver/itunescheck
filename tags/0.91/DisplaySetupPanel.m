#import "DisplaySetupPanel.h"

@implementation DisplaySetupPanel

static id _sharedDisplaySetupPanel = nil;
+ (id) sharedPanel
{
    if (_sharedDisplaySetupPanel == nil)
    {
        _sharedDisplaySetupPanel = [[self alloc] init];
    }
    
    return _sharedDisplaySetupPanel;
}

- (id) init
{
    return [self initWithWindowNibName:@"DisplaySetup"];
}

- (void) awakeFromNib
{
    [[[textView superview] superview] setDrawsBackground:NO];
    [[textView superview] setDrawsBackground:NO];
    [textView setDrawsBackground:NO];
    [_roundedView bind:@"backgroundColor"
              toObject:[NSUserDefaultsController sharedUserDefaultsController]
           withKeyPath:@"values.infoWindowBackgroundColor"
               options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
}

- (void) dealloc
{
    [displayString release];
    [super dealloc];
}

- (void) runModalForAttributedString:(NSAttributedString *)str
{
    int resultCode;
    [[textView textStorage] setAttributedString:str];
    
    resultCode = [NSApp runModalForWindow: [self window]];
	[[self window] orderOut:self];
    
	if( resultCode == NSOKButton )
	{
		[[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:[[textView textStorage] attributedSubstringFromRange:NSMakeRange(0, [[textView textStorage] length])]] forKey:@"displayString"];
	}
}

- (void) setDisplayString:(NSAttributedString *)str
{
    [str retain];
    [displayString release];
    
    displayString = str;
}

- (NSAttributedString *) displayString
{
    return displayString;
}

- (IBAction)ok: (id)sender
{
    [NSApp stopModalWithCode:NSOKButton];
    [[NSFontPanel sharedFontPanel] close];
    [[[NSApp delegate] infoController] display];
}

- (IBAction)cancel: (id)sender
{
    [NSApp stopModalWithCode:NSCancelButton];
    [[NSFontPanel sharedFontPanel] close];
}

- (IBAction) toggleFontPanel:(id)sender
{
    NSWindow *fontPanel = [NSFontPanel sharedFontPanel];
    if ([fontPanel isVisible])
        [fontPanel close];
    else
    {
        [textView updateFontPanel];
        [fontPanel orderFront:self];
    }
}


@end
