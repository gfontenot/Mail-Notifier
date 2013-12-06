//
//  MNInbox.m
//  Mail Notifier
//
//  Created by Gordon Fontenot on 11/21/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

#import "MNInbox.h"

NSString * const MNInboxDidUpdateNotification = @"com.gfontenot.mail-notifier.inbox-updated";

@interface MNInbox ()

@property (nonatomic) NSString *inboxPath;

@end

@implementation MNInbox

- (instancetype)initWithInboxPath:(NSString *)inboxPath
{
    self = [super init];
    if (!self) return nil;
    self.inboxPath = inboxPath;
    [self registerForFSEvents];
    return self;
}

- (NSInteger)emailCount
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    __block NSInteger emailCount = 0;
    [[fileManager contentsOfDirectoryAtPath:self.inboxPath error:nil] enumerateObjectsUsingBlock:^(NSString *box, NSUInteger idx, BOOL *stop) {
        NSString *mboxPath = [self.inboxPath stringByAppendingPathComponent:box];
        emailCount += [[fileManager contentsOfDirectoryAtPath:mboxPath error:nil] count];
    }];

    return emailCount;
}

- (NSString *)name
{
    NSString *accountPath = [self.inboxPath stringByReplacingOccurrencesOfString:@"INBOX" withString:@""];
    NSString *rootName = [accountPath lastPathComponent];
    return [rootName stringByReplacingOccurrencesOfString:@"-" withString:@"@"];
}

#pragma mark - Private Methods

- (void)registerForFSEvents
{
    CFStringRef inboxPath = (__bridge CFStringRef)self.inboxPath;
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&inboxPath, 1, NULL);
    void *callbackInfo = NULL;
    CFAbsoluteTime latency = 3.0;

    FSEventStreamRef stream = FSEventStreamCreate(NULL, &inboxUpdated, callbackInfo, pathsToWatch, kFSEventStreamEventIdSinceNow, latency, kFSEventStreamCreateFlagNone);
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    FSEventStreamStart(stream);
}

#pragma mark - FSEvent Callback

static void inboxUpdated(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MNInboxDidUpdateNotification object:nil];
}

@end
