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
#import "MNMenuItem.h"

@interface MNStatusController ()

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) MNMailboxParser *parser;

@end

@implementation MNStatusController

#pragma mark - Object lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public methods

- (void)setupStatusItem
{
    self.parser = [[MNMailboxParser alloc] init];
    NSString *mailDir = [NSString stringWithFormat:@"%@/.mail", NSHomeDirectory()];
    [self.parser parseMailboxesAtPath:mailDir];
    [self updateStatusItem];
    [self registerForNotifications];
}

#pragma mark - Notifications

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusItem) name:MNInboxDidUpdateNotification object:nil];
}

#pragma mark - Status item configuration

- (void)updateStatusItem
{
    NSInteger emailCount = [self.parser emailCount];
    if (emailCount) {
        [self configureStatusItemForEmailCount:emailCount];
        [self configureStatusMenu];
    } else {
        [self removeStatusItem];
    }
}

- (void)configureStatusItemForEmailCount:(NSInteger)emailCount
{
    if (emailCount > 1) {
        self.statusItem.title = [NSString stringWithFormat:@"%@", @(emailCount)];
    } else {
        self.statusItem.title = @"";
    }
}

- (void)configureStatusMenu
{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Emails"];
    NSArray *inboxes = [self.parser inboxes];
    [inboxes enumerateObjectsUsingBlock:^(MNInbox *inbox, NSUInteger idx, BOOL *stop) {
        MNMenuItem *item = [[MNMenuItem alloc] init];
        [item setTitleText:[inbox name]];
        [item setDetailText:[NSString stringWithFormat:@"(%@)", @([inbox emailCount])]];
        [menu addItem:item];
    }];

    self.statusItem.menu = menu;
}

- (void)removeStatusItem
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
    self.statusItem = nil;
}

#pragma mark - Lazy initialization

- (NSStatusItem *)statusItem
{
    if (!_statusItem) {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        _statusItem.image = [NSImage imageNamed:@"MenubarIcon"];
        _statusItem.alternateImage = [NSImage imageNamed:@"MenuBarIconHighlighted"];
        _statusItem.highlightMode = YES;
    }

    return _statusItem;
}

@end
