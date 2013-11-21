//
//  MNAppDelegate.m
//  Mail Notifier
//
//  Created by Gordon Fontenot on 11/15/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

#include <CoreServices/CoreServices.h>
#import "MNAppDelegate.h"

@interface MNAppDelegate ()

@property (nonatomic, weak) IBOutlet NSMenu *statusMenu;
@property (nonatomic, strong) NSStatusItem *statusItem;

@end

@implementation MNAppDelegate

static void inboxUpdated(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    MNAppDelegate *delegate = [[NSApplication sharedApplication] delegate];
    [delegate updateStatusTitle];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self updateStatusTitle];
}

- (void)updateStatusTitle
{
    __block NSInteger emailCount = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mailDir = [NSString stringWithFormat:@"%@/.mail", NSHomeDirectory()];
    NSArray *mailDirectories = [fileManager contentsOfDirectoryAtPath:mailDir error:nil];
    [mailDirectories enumerateObjectsUsingBlock:^(NSString *mailbox, NSUInteger idx, BOOL *stop) {
        NSString *mailboxPath = [mailDir stringByAppendingPathComponent:mailbox];
        NSString *inbox = [mailboxPath stringByAppendingPathComponent:@"INBOX"];
        if ([fileManager fileExistsAtPath:inbox]) {
            [self createFSStreamForInbox:inbox];
            [[fileManager contentsOfDirectoryAtPath:inbox error:nil] enumerateObjectsUsingBlock:^(NSString *box, NSUInteger idx, BOOL *stop) {
                NSString *mbox = [inbox stringByAppendingPathComponent:box];
                emailCount += [[fileManager contentsOfDirectoryAtPath:mbox error:nil] count];
            }];
        }
    }];

    self.statusItem.image = [NSImage imageNamed:@"MenubarIcon"];
    self.statusItem.title = [NSString stringWithFormat:@" %@", @(emailCount)];
}

- (void)createFSStreamForInbox:(NSString *)inbox
{
    CFStringRef inboxPath = (__bridge CFStringRef)inbox;
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&inboxPath, 1, NULL);
    void *callbackInfo = NULL;
    CFAbsoluteTime latency = 3.0;

    FSEventStreamRef stream = FSEventStreamCreate(NULL, &inboxUpdated, callbackInfo, pathsToWatch, kFSEventStreamEventIdSinceNow, latency, kFSEventStreamCreateFlagNone);
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    FSEventStreamStart(stream);
}

@end
