//
//  MNMailboxParser.m
//  Mail Notifier
//
//  Created by Gordon Fontenot on 11/21/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

#import "MNMailboxParser.h"
#import "MNInbox.h"

@interface MNMailboxParser ()

@property (nonatomic) NSMutableArray *_inboxes;

@end

@implementation MNMailboxParser

- (void)parseMailboxesAtPath:(NSString *)mailboxPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *mailDirectories = [fileManager contentsOfDirectoryAtPath:mailboxPath error:nil];
    [mailDirectories enumerateObjectsUsingBlock:^(NSString *mailbox, NSUInteger idx, BOOL *stop) {
        NSString *accountMailboxPath = [mailboxPath stringByAppendingPathComponent:mailbox];
        NSString *inbox = [accountMailboxPath stringByAppendingPathComponent:@"INBOX"];
        if ([fileManager fileExistsAtPath:inbox]) {
            [self._inboxes addObject:[[MNInbox alloc] initWithInboxPath:inbox]];
        }
    }];
}

- (NSArray *)inboxes
{
    return [self._inboxes copy];
}

- (NSInteger)emailCount
{
    NSInteger count = [[self._inboxes valueForKeyPath:@"@sum.self.emailCount"] integerValue];
    return count;
}

- (NSMutableArray *)_inboxes
{
    if (!__inboxes) {
        __inboxes = [NSMutableArray array];
    }

    return __inboxes;
}

@end
