//
//  DisplayPluginsController.h
//  iTunesCheck
//
//  Created by StormSilver on 8/29/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DisplayPluginsController : NSObject
{
    IBOutlet NSTextView *displaySetupField;
    IBOutlet NSTableView *displayTable;
    IBOutlet id objectController;
    
    NSMutableDictionary *displayPlugins;
    NSString *thirdPartyPlugins;
}

- (IBAction) loadPlugins:(id)sender;
- (void) parsePlugins:(NSString *)directory;

- (NSArray *) displayPlugins;
- (void) setDisplayPlugins:(NSDictionary *)plugins;

- (NSString *) runPlugin:(NSString *)name;
- (NSMutableAttributedString *) retrieveInfo;

@end
