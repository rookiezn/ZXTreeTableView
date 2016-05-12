//
//  ZXViewController.m
//  ZXTreeTableView
//
//  Created by rookiezn on 05/11/2016.
//  Copyright (c) 2016 rookiezn. All rights reserved.
//

#import "ZXViewController.h"
#import <ZXTreeTableView/ZXTreeTableView.h>

static NSString *token = @"cell";

@interface ZXViewController () <ZXTreeTableViewDelegate>

@end

@implementation ZXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ZXTreeTableView *tableView = [[ZXTreeTableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    tableView.zxTreeTableViewDelegate = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:token];
    [self.view addSubview:tableView];
}

#pragma mark - ZXTreeTableViewDelegate

- (NSArray *)rootNodesForZXTreeTableView:(ZXTreeTableView *)treeTableView {
    NSMutableArray *rootNodes = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
        ZXTreeNode *rootNode = [[ZXTreeNode alloc] init];
        NSMutableArray *subNodes = [NSMutableArray array];
        for (int j = 0; j < 5; ++j) {
            ZXTreeNode *subNode = [[ZXTreeNode alloc] init];
            NSMutableArray *subNodes1 = [NSMutableArray array];
            for (int k = 0; k < 5; ++k) {
                ZXTreeNode *subNode1 = [[ZXTreeNode alloc] init];
                [subNodes1 addObject:subNode1];
            }
            subNode.children = subNodes1;
            [subNodes addObject:subNode];
        }
        rootNode.children = subNodes;
        rootNode.shouldExclusiveExpand = YES;
        [rootNodes addObject:rootNode];
    }
    return rootNodes;
}

- (void)zxTreeTableView:(ZXTreeTableView *)treeTableView didSelectNode:(ZXTreeNode *)node {
    [treeTableView toggleNode:node animated:YES];
    NSIndexPath *indexPath = [treeTableView indexPathForNode:node];
    [treeTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"did select node: %@", node);
}

- (UITableViewCell *)zxTreeTableView:(ZXTreeTableView *)treeTableView cellAtNode:(ZXTreeNode *)node {
    UITableViewCell *cell = [treeTableView dequeueReusableCellWithIdentifier:token forNode:node];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = node.description;
    return cell;
}

@end
