/* DisplaySetupPanel */

#import <Cocoa/Cocoa.h>
#import "RoundedView.h"

@interface DisplaySetupPanel : NSWindowController
{
    IBOutlet NSTextView *textView;
    IBOutlet NSTableView *table;
    IBOutlet RoundedView *      _roundedView;
    
    NSAttributedString *displayString;
}

+ (id) sharedPanel;

- (void) runModalForAttributedString:(NSAttributedString *)str;

- (void) setDisplayString:(NSAttributedString *)str;
- (NSAttributedString *) displayString;

- (IBAction)ok: (id)sender;
- (IBAction)cancel: (id)sender;
- (IBAction) toggleFontPanel:(id)sender;

@end
