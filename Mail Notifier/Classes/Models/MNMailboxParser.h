//
//  MNMailboxParser.h
//  Mail Notifier
//
//  Created by Gordon Fontenot on 11/21/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

@interface MNMailboxParser : NSObject

- (void)parseMailboxesAtPath:(NSString *)mailboxPath;
- (NSArray *)inboxes;
- (NSInteger)emailCount;

@end
