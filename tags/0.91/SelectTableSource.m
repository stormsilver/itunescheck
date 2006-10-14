#import "SelectTableSource.h"
#import "InfoController.h"

@implementation SelectTableSource

- (id) init
{
    if (self = [super init])
    {
        //Load up our data array with the desired content
        data = [[NSMutableArray alloc] init];
        
        return self;
    }
    
    return nil;
}

- (void) dealloc
{
    [data release];
    
    [super dealloc];
}

- (void) awakeFromNib
{
    [itemsTable setTarget:self];
    [itemsTable setAction:@selector(tableViewClicked:)];
    [itemsTable setDoubleAction:@selector(tableViewDoubleClicked:)];
}

- (void) setDataArray:(NSMutableArray *)arr
{
    if ([arr count] > 0)
    {
        [arr retain];
        [data release];
        data = arr;
        [itemsTable reloadData];
    }
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [data count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn row:(int)rowIndex
{
    //NSLog(@"tableView: objectValueForTableColumn: row:");
    NSString *rval = @"";
    if ([data count] > 0)
    {
        if ([[aTableColumn identifier] isEqual:@"title"])
            rval = [[data objectAtIndex:rowIndex] objectAtIndex:0];
        else if ([[aTableColumn identifier] isEqual:@"artist"])
            rval = [[data objectAtIndex:rowIndex] objectAtIndex:1];
    }
    return rval;
}

- (IBAction) tableViewClicked:(id)sender
{
    /*
    NSString *file = @"/tmp/";
    [file stringByAppendingString:[[data objectAtIndex:[itemsTable selectedRow]] objectAtIndex:3]];
    [file stringByAppendingString:@".pict"];
    
    NSString * path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/artwork.applescript"];
    NSMutableString * script = [NSMutableString stringWithContentsOfFile:path];
    [script replaceOccurrencesOfString:@"replaceValue" withString:[[data objectAtIndex:[itemsTable selectedRow]] lastObject] options:NSLiteralSearch range:NSMakeRange(0, [script length])];
    [script replaceOccurrencesOfString:@"imgName" withString:file options:NSLiteralSearch range:NSMakeRange(0, [script length])];
    NSString *album = [[[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil] stringValue];
    
    [titleField setStringValue:[[data objectAtIndex:[itemsTable selectedRow]] objectAtIndex:0]];
    [artistField setStringValue:[[data objectAtIndex:[itemsTable selectedRow]] objectAtIndex:1]];
    [albumField setStringValue:album];
    [imageView setImage:[[NSImage alloc] initWithContentsOfFile:file]];
     */
    //NSLog(@"single click: %i", [detailDrawer state]);
    /*
    NSDrawerState state = [detailDrawer state];
    if (NSDrawerClosedState == state || NSDrawerClosingState == state) {
        [detailDrawer openOnEdge:NSMinYEdge];
    }
    [titleField setStringValue:[[data objectAtIndex:[itemsTable selectedRow]] objectAtIndex:0]];
    [artistField setStringValue:[[data objectAtIndex:[itemsTable selectedRow]] objectAtIndex:1]];
    [albumField setStringValue:[[data objectAtIndex:[itemsTable selectedRow]] objectAtIndex:2]];
    [ratingField setStringValue:[[data objectAtIndex:[itemsTable selectedRow]] objectAtIndex:3]];
     */
    //[detailDrawer open];
    //NSLog(@"state: %i", [detailDrawer state]);
}

- (IBAction) tableViewDoubleClicked:(id)sender
{
    if ([itemsTable selectedRow] > -1)
    {
        NSString *script = [[NSString alloc] initWithFormat:@"tell application \"iTunes\"\nplay %@\nend tell", [[data objectAtIndex:[itemsTable selectedRow]] lastObject]];
        NSAppleScript *theScript = [[NSAppleScript alloc] initWithSource:script];
        NSDictionary *errorDict = [[NSDictionary alloc] init];
        if (![theScript executeAndReturnError:&errorDict])
        {
            NSLog(@"Error playing song!\n%@", errorDict);
            [theScript release];
            exit(-1);
        }
        [errorDict release];
		[theScript release];
        
		[selectWindow close];
        [[InfoController sharedController] display];
    }
}

- (IBAction) createPlaylist:(id)sender
{
    NSMutableString *script = [NSMutableString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/createPlaylist.applescript"]];
    int row = 0;
    if ([itemsTable selectedRow] > -1)
    {
        row = [itemsTable selectedRow];
    }
    [script replaceOccurrencesOfString:@"songValue" withString:[[data objectAtIndex:row] objectAtIndex:0] options:NSLiteralSearch range:NSMakeRange(0, [script length])];
    [script replaceOccurrencesOfString:@"artistValue" withString:[[data objectAtIndex:row] objectAtIndex:1] options:NSLiteralSearch range:NSMakeRange(0, [script length])];
    NSMutableString *playlistValue = [[[data objectAtIndex:0] lastObject] mutableCopy];
    NSLog(playlistValue);
    for (int i = 1; i < [data count]; ++i)
    {
        [playlistValue appendString:@", "];
        [playlistValue appendString:[[data objectAtIndex:i] lastObject]];
    }
    
    [script replaceOccurrencesOfString:@"listValue" withString:playlistValue options:NSLiteralSearch range:NSMakeRange(0, [script length])];
	NSAppleScript *theScript = [[NSAppleScript alloc] initWithSource:script];
	NSDictionary *errorDict = [[NSDictionary alloc] init];
    [theScript executeAndReturnError:&errorDict];
	[errorDict release];
	[theScript release];
	
    [selectWindow close];
    [[InfoController sharedController] display];
}

- (void) clearData
{
    [data removeAllObjects];
}

@end
