//
//  ZXViewController.m
//  ZXTreeTableView
//
//  Created by rookiezn on 05/11/2016.
//  Copyright (c) 2016 rookiezn. All rights reserved.
//

#import "ZXViewController.h"
#import <ZXTreeTableView/ZXTreeTableView.h>
#import "SwitcherNode.h"
#import <objc/runtime.h>
#import "Masonry/Masonry.h"

static NSString *token = @"cell";

@interface ZXViewController () <ZXTreeTableViewDelegate>

@property (nonatomic, strong) NSMutableArray<SwitcherNode *> *rootNodes;

@end

@implementation ZXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZXTreeTableView *tableView = [[ZXTreeTableView alloc] init];
    tableView.zxTreeTableViewDelegate = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
}

- (NSArray *)rootNodesForZXTreeTableView:(ZXTreeTableView *)treeTableView {
    _rootNodes = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
        SwitcherNode *node = [SwitcherNode new];
        [_rootNodes addObject:node];
        NSMutableArray *subNodes = [NSMutableArray array];
        for (int j = 0; j < 2; ++j) {
            SwitcherNode *subNode = [SwitcherNode new];
            [subNodes addObject:subNode];
            NSMutableArray *subSubNodes = [NSMutableArray array];
            for (int k = 0; k < 3; ++k) {
                SwitcherNode *subSubNode = [SwitcherNode new];
                [subSubNodes addObject:subSubNode];
            }
            subNode.children = subSubNodes;
        }
        node.children = subNodes;
    }
    return _rootNodes;
}

- (UITableViewCell *)zxTreeTableView:(ZXTreeTableView *)treeTableView cellAtNode:(ZXTreeNode *)node {
    SwitcherNode *switcherNode = (SwitcherNode *)node;
    UITableViewCell *cell = [treeTableView dequeueReusableCellWithIdentifier:@"cell" forNode:node];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *title = [UILabel new];
    title.text = node.description;
    NSInteger depth = node.hierarchy.count;
    CGFloat padding = 15;
    [cell.contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(depth * padding);
    }];
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"angle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    accessoryView.tintColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:accessoryView];
    [accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    switcherNode.accessoryView = accessoryView;
    
    UISwitch *switcher = [UISwitch new];
    switcher.on = switcherNode.on;
    [cell.contentView addSubview:switcher];
    [switcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(accessoryView.mas_left).offset(-20);
    }];
    switcherNode.switcher = switcher;
    objc_setAssociatedObject(switcher, @"node", switcherNode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [switcher addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (void)zxTreeTableView:(ZXTreeTableView *)treeTableView didSelectNode:(ZXTreeNode *)node {
    NSIndexPath *indexPath = [treeTableView indexPathForNode:node];
    [treeTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (node.children.count != 0) {
        [treeTableView toggleNode:node animated:YES];
    }
}

- (CGFloat)zxTreeTableView:(ZXTreeTableView *)treeTableView heightForNode:(ZXTreeNode *)node {
    return 50;
}

- (void)handleSwitch:(UISwitch *)sender {
    SwitcherNode *node = objc_getAssociatedObject(sender, @"node");
    node.on = sender.on;
    for (SwitcherNode *child in node.descendant) {
        child.on = sender.on;
        [child.switcher setOn:sender.on animated:YES];
    }
    if (sender.on) {
        for (SwitcherNode *ancestor in node.ancestor) {
            [ancestor.switcher setOn:YES animated:YES];
        }
    } else {
        for (SwitcherNode *ancestor in node.ancestor) {
            BOOL shouldOff = YES;
            for (SwitcherNode *descendant in ancestor.descendant) {
                if (descendant.switcher.on) {
                    shouldOff = NO;
                }
            }
            if (shouldOff) {
                [ancestor.switcher setOn:NO animated:YES];
            }
        }
    }
}

@end
