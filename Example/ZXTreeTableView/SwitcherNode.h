//
//  SwitcherNode.h
//  ZXTreeTableView
//
//  Created by Zinc on 5/12/16.
//  Copyright © 2016 rookiezn. All rights reserved.
//

#import <ZXTreeTableView/ZXTreeTableView.h>

@interface SwitcherNode : ZXTreeNode

@property (nonatomic, weak) UISwitch *switcher;
@property (nonatomic, weak) UIImageView *accessoryView;
@property (nonatomic, assign) BOOL on;

@end
