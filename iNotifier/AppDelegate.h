//
//  AppDelegate.h
//  iNotifier
//
//  Created by Tse Kit Yam on 27/9/14.
//  Copyright (c) 2014 Tse Kit Yam. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource> {
@private
    __weak IBOutlet NSTextField *_textField_date;
    __weak IBOutlet NSTextField *_textField_time;
    __weak IBOutlet NSTableView *_tableView;
    __weak IBOutlet NSButton *_button;
    NSDictionary *_availability;
    NSDictionary *_store;
    NSTimer *timer;
    BOOL available;
}
- (IBAction)refresh:(id)sender;

@end

