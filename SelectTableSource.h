/* TableSource */

#import <Cocoa/Cocoa.h>

@interface SelectTableSource : NSObject
{
    IBOutlet NSTableView * itemsTable;
    IBOutlet NSWindow *selectWindow;
    /*
    IBOutlet id detailDrawer;
    IBOutlet id ratingField;
    IBOutlet id titleField;
    IBOutlet id artistField;
    IBOutlet id albumField;
     */
    
    NSMutableArray * data;
}

- (IBAction) tableViewClicked:(id)sender;
- (IBAction) tableViewDoubleClicked:(id)sender;
- (IBAction) createPlaylist:(id)sender;
- (void) setDataArray:(NSMutableArray *)arr;
- (void) clearData;

@end
