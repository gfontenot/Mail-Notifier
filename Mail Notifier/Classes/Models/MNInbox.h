//
//  MNInbox.h
//  Mail Notifier
//
//  Created by Gordon Fontenot on 11/21/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

extern NSString *const MNInboxDidUpdateNotification;

@interface MNInbox : NSObject

- (instancetype)initWithInboxPath:(NSString *)inboxPath;
- (NSInteger)emailCount;
- (NSString *)name;

@end
