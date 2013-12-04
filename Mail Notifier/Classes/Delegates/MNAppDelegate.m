//
//  MNAppDelegate.m
//  Mail Notifier
//
//  Created by Gordon Fontenot on 11/15/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

#include <CoreServices/CoreServices.h>
#import "MNAppDelegate.h"
#import "MNMailboxParser.h"
#import "MNInbox.h"

@interface MNAppDelegate ()

@property (nonatomic) IBOutlet NSMenu *statusMenu;
@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) MNMailboxParser *parser;

@end

@implementation MNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.parser = [[MNMailboxParser alloc] init];
    NSString *mailDir = [NSString stringWithFormat:@"%@/.mail", NSHomeDirectory()];
    [self.parser parseMailboxesAtPath:mailDir];
    [self updateStatusTitle];
    [self registerForNotifications];
}

- (void)updateStatusTitle
{
    self.statusItem.image = [NSImage imageNamed:@"MenubarIcon"];
    self.statusItem.title = [NSString stringWithFormat:@"%@", @([self.parser emailCount])];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusTitle) name:MNInboxDidUpdateNotification object:nil];
}

@end
