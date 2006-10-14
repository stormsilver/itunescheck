/* FindController */

#import <Cocoa/Cocoa.h>
#import "InfoController.h"


@interface FindController : NSObject
{
    IBOutlet id _findWindow;
    IBOutlet id _selectWindow;
    IBOutlet id _findField;
    IBOutlet id _selectTable;
    IBOutlet id _findRounded;
    IBOutlet id _selectRounded;
    IBOutlet id _numResultsField;
    IBOutlet id _searchProgressIndicator;
    IBOutlet id _playlistMenu;
    IBOutlet NSTextField *          _errorField;
    
    InfoController *_infoController;
    
    NSMutableArray *_playlists;
}

+ (id) sharedController;

- (IBAction) close:(id)sender;
- (void) display;

- (IBAction) performFind:(id)sender;
- (IBAction) cancelSelect:(id)sender;
- (IBAction) refreshPlaylists:(id)sender;
- (IBAction) playList:(id)sender;

- (void) showError:(NSString *)errorMessage;
- (void) clearError;

@end
