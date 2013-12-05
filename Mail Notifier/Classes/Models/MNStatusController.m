//
//  MNStatusController.m
//  Mail Notifier
//
//  Created by Gordon Fontenot on 12/5/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

#import "MNStatusController.h"
#import "MNMailboxParser.h"
#import "MNInbox.h"

@interface MNStatusController ()

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) MNMailboxParser *parser;

@end

@implementation MNStatusController

- (void)setupStatusItem
{
    self.parser = [[MNMailboxParser alloc] init];
    NSString *mailDir = [NSString stringWithFormat:@"%@/.mail", NSHomeDirectory()];
    [self.parser parseMailboxesAtPath:mailDir];
    [self updateStatusTitle];
    [self registerForNotifications];
}

- (void)updateStatusTitle
{
    NSInteger emailCount = [self.parser emailCount];
    if (emailCount) {
        self.statusItem.image = [NSImage imageNamed:@"MenubarIcon"];
        self.statusItem.title = [NSString stringWithFormat:@"%@", @(emailCount)];
    } else {
        [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
        self.statusItem = nil;
    }
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusTitle) name:MNInboxDidUpdateNotification object:nil];
}

#pragma mark - Lazy initialization

- (NSStatusItem *)statusItem
{
    if (!_statusItem) {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    }

    return _statusItem;
}

@end
