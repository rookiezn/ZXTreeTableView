//
//  ZXTreeTableView.m
//  ZXTreeTableView
//
//  Created by Zinc on 16/5/10.
//  Copyright © 2016年 Zinc. All rights reserved.
//

#import "ZXTreeTableView.h"

@interface ZXTreeTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<ZXTreeNode *> *rootNodes;

@end

@implementation ZXTreeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (style == UITableViewStyleGrouped) {
        [NSException raise:@"init error" format:@"ZXTreeTableView only supports plain style"];
    }
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    if (delegate != self) {
        [NSException raise:@"delegate error" format:@"UITableView delegate can only be \"self\", use zxTreeTableViewDelegate instead"];
    }
    [super setDelegate:self];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    if (dataSource != self) {
        [NSException raise:@"dataSource error" format:@"UITableView dataSource can only be \"self\", use zxTreeTableViewDelegate instead"];
    }
    [super setDataSource:self];
}

- (ZXTreeNode *)nodeForIndexPath:(NSIndexPath *)indexPath {
    return self.allNodes[indexPath.row];
}

- (NSIndexPath *)indexPathForNode:(ZXTreeNode *)node {
    NSInteger row = [self.allNodes indexOfObject:node];
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (void)toggleNode:(ZXTreeNode *)node animated:(BOOL)animated {
    if (node.shouldExclusiveExpand && !node.isExpanded) {
        NSArray *siblings = node.parent ? node.parent.children : _rootNodes;
        for (ZXTreeNode *child in siblings) {
            if (child.isExpanded) {
                child.expanded = NO;
                [self toggleNode:child expanded:NO animated:NO];
            }
        }
    }
    node.expanded = !node.isExpanded;
    [self toggleNode:node expanded:node.isExpanded animated:YES];
}

- (void)toggleNode:(ZXTreeNode *)node expanded:(BOOL)expanded animated:(BOOL)animated {
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    NSInteger row = [self indexPathForNode:node].row;
    NSMutableArray *indexPathArr = [NSMutableArray array];
    NSMutableArray *nodes = [NSMutableArray array];
    [self flattenNode:node to:nodes];
    for (int i = 0; i < nodes.count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row+i+1 inSection:0];
        [indexPathArr addObject:indexPath];
    }
    if (expanded) {
        [self insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationTop];
    }
    [UIView setAnimationsEnabled:YES];
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forNode:(ZXTreeNode *)node {
    NSIndexPath *indexPath = [self indexPathForNode:node];
    return [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXTreeNode *node = [self nodeForIndexPath:indexPath];
    return [self.zxTreeTableViewDelegate zxTreeTableView:self cellAtNode:node];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.zxTreeTableViewDelegate respondsToSelector:@selector(zxTreeTableView:heightForNode:)]) {
        ZXTreeNode *node = [self nodeForIndexPath:indexPath];
        return [self.zxTreeTableViewDelegate zxTreeTableView:self heightForNode:node];
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXTreeNode *node = [self nodeForIndexPath:indexPath];
    if ([self.zxTreeTableViewDelegate respondsToSelector:@selector(zxTreeTableView:didSelectNode:)]) {
        [self.zxTreeTableViewDelegate zxTreeTableView:self didSelectNode:node];
    }
}

#pragma mark - Utils

- (NSArray<ZXTreeNode *> *)rootNodes {
    if (!_rootNodes) {
        _rootNodes = [self.zxTreeTableViewDelegate rootNodesForZXTreeTableView:self];
        for (int i = 0; i < _rootNodes.count; ++i) {
            _rootNodes[i].hierarchy = @[@(i)];
        }
    }
    return _rootNodes;
}

/**
 *  get all root nodes and expanded nodes in order
 *
 *  @return all visible nodes
 */
- (NSArray<ZXTreeNode *> *)allNodes {
    NSMutableArray *allNodes = [NSMutableArray array];
    for (ZXTreeNode *node in self.rootNodes) {
        [allNodes addObject:node];
        if (node.isExpanded) {
            [self flattenNode:node to:allNodes];
        }
    }
    return allNodes;
}

/**
 *  flatten descendent nodes to the array
 *  [[a, [b, c]], d] => [a, b, c, d]
 *
 *  @param node   node
 *  @param result result
 */
- (void)flattenNode:(ZXTreeNode *)node to:(NSMutableArray *)result {
    for (ZXTreeNode *child in node.children) {
        [result addObject:child];
        if (child.isExpanded) {
            [self flattenNode:child to:result];
        }
    }
}

@end
