//
//  SwitcherNode.m
//  ZXTreeTableView
//
//  Created by Zinc on 5/12/16.
//  Copyright © 2016 rookiezn. All rights reserved.
//

#import "SwitcherNode.h"

@implementation SwitcherNode

- (void)setExpanded:(BOOL)expanded {
    [super setExpanded:expanded];
    [UIView animateWithDuration:0.25 animations:^{
        _accessoryView.transform = expanded ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity;
    }];
}

@end
