//
//  AppDelegate.m
//  iNotifier
//
//  Created by Tse Kit Yam on 27/9/14.
//  Copyright (c) 2014 Tse Kit Yam. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

static NSString *model[] = {
    @"MGAF2ZP/A",   // 6 Plus   Gold    128
    @"MG492ZP/A",   // 6        Gold    16
    @"MGAC2ZP/A",   //
    @"MGA92ZP/A",   //
    @"MG4F2ZP/A",   // 6        Black   64
    @"MG472ZP/A",   // 6        Black   16
    @"MG4A2ZP/A",   // 6        Black   128
    @"MGAK2ZP/A",   //
    @"MGAA2ZP/A",   // 6 Plus   Gold    16
    @"MG4J2ZP/A",   // 6        Gold    64
    @"MGAJ2ZP/A",   //
    @"MG4H2ZP/A",   // 6        Silver  16
    @"MGAE2ZP/A",   //
    @"MG4E2ZP/A",   // 6        Gold    128
    @"MG482ZP/A",   // 6        Silver  64
    @"MGAH2ZP/A",
    @"MG4C2ZP/A",   // 6        Silver  128
    @"MGA82ZP/A"    // 6 Plus   Black   16
};

static NSString *store[] = {
    @"R409", // Causeway Bay
    @"R428", // ifc mall
    @"R485"  // Festival Walk
};

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    available = NO;
    [self refresh:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 18*3;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSDictionary *dictionary = [_tableContents objectAtIndex:row];
    
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"Store"]) {
        NSTextField *textField = [tableView makeViewWithIdentifier:identifier owner:self];
        [textField setStringValue:store[row/18]];
        return textField;
    } else if ([identifier isEqualToString:@"Model"]) {
        NSTextField *textField = [tableView makeViewWithIdentifier:identifier owner:self];
        [textField setStringValue:model[row%18]];
        return textField;
    } else if ([identifier isEqualToString:@"Quantity"]) {
        if (_availability == nil) {
            return nil;
        }
        NSTextField *textField = [tableView makeViewWithIdentifier:identifier owner:self];
        [textField setStringValue:[[_availability objectForKey:store[row/18]] objectForKey:model[row%18]]];
        return textField;
    } else {
        NSAssert1(NO, @"Unhandled table column identifier %@", identifier);
    }
    
    return nil;
}

- (IBAction)refresh:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(refresh:) userInfo:nil repeats:YES];;
    [_button setStringValue:@"start"];
    NSURLRequest *availabilityRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://reserve.cdn-apple.com/HK/zh_HK/reserve/iPhone/availability.json"]];
    NSData *avilablityRespond = [NSURLConnection sendSynchronousRequest:availabilityRequest returningResponse:nil error:nil];
    _availability = [NSJSONSerialization JSONObjectWithData:avilablityRespond options:0 error:nil];
    
    NSURLRequest *storeRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://reserve.cdn-apple.com/HK/zh_HK/reserve/iPhone/stores.json"]];
    NSData *storeRespond = [NSURLConnection sendSynchronousRequest:storeRequest returningResponse:nil error:nil];
    _store = [NSJSONSerialization JSONObjectWithData:storeRespond options:0 error:nil];
    
    available = NO;
    for (int i = 0; i < 54; i++) {
        if ([[[_availability objectForKey:store[i/18]] objectForKey:model[i%18]] boolValue]) {
            available = YES;
        }
    }
    
    [_tableView reloadData];
    [_textField_time setStringValue:[_store objectForKey:@"updatedTime"]];
    [_textField_date setStringValue:[_store objectForKey:@"updatedDate"]];
    
    if (available) {
        [timer invalidate];
        [_button setTitle:@"Restart"];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"iPhone is available!!"];
        [alert setInformativeText:@"Click OK to go to Apple reservation page."];
        [alert setAlertStyle:NSWarningAlertStyle];
        if ([alert runModal] == NSAlertFirstButtonReturn) {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: @"https://reserve.cdn-apple.com/HK/zh_HK/reserve/iPhone/availability"]];
        }
    }
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode
        contextInfo:(void *)contextInfo {
}
@end
