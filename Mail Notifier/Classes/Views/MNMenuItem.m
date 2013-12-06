//
//  MNMenuItem.m
//  Mail Notifier
//
//  Created by Gordon Fontenot on 12/5/13.
//  Copyright (c) 2013 Gordon Fontenot. All rights reserved.
//

#import "MNMenuItem.h"

@interface MNMenuItem ()

@property (nonatomic, strong) IBOutlet NSView *internalView;
@property (nonatomic, strong) IBOutlet NSTextField *titleLabel;
@property (nonatomic, strong) IBOutlet NSTextField *detailLabel;

@end

@implementation MNMenuItem

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    [super setTitle:@""];
    [[NSBundle mainBundle] loadNibNamed:@"MNMenuItemView" owner:self topLevelObjects:nil];
    self.view = self.internalView;
    return self;
}


- (void)setTitleText:(NSString *)text
{
    [self updateLabel:self.titleLabel withText:text];
}

- (void)setDetailText:(NSString *)text
{
    [self updateLabel:self.detailLabel withText:text];
}

#pragma mark - Private helpers

- (void)updateLabel:(NSTextField *)label withText:(NSString *)text
{
    [label setStringValue:text];
    [label sizeToFit];
    [self.internalView setNeedsLayout:YES];
}

@end
