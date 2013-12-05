//
//  MNAppDelegate.m
//  Mail Notifier
//
//  Created by Gordon Fontenot on 11/15/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

#include <CoreServices/CoreServices.h>
#import "MNAppDelegate.h"
#import "MNStatusController.h"

@interface MNAppDelegate ()

@property (nonatomic) MNStatusController *statusController;

@end

@implementation MNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.statusController = [[MNStatusController alloc] init];
    [self.statusController setupStatusItem];
}

@end
