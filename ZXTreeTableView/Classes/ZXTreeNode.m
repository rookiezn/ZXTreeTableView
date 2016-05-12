//
//  ZXTreeNode.m
//  ZXTreeTableView
//
//  Created by Zinc on 16/5/10.
//  Copyright © 2016年 Zinc. All rights reserved.
//

#import "ZXTreeNode.h"

@implementation ZXTreeNode

- (void)setChildren:(NSArray<ZXTreeNode *> *)children {
    _children = children;
    for (ZXTreeNode *child in children) {
        if (child.parent) {
            [NSException raise:@"bind children error" format:@"the child is already having a parnet"];
        }
        child.parent = self;
    }
}

- (NSArray *)hierarchy {
    if (!_hierarchy) {
        NSMutableArray *result = [NSMutableArray array];
        [self flattenHierarchyForNode:self to:result];
        _hierarchy = result;
    }
    return _hierarchy;
}

- (NSArray *)descendant {
    NSMutableArray *result = [NSMutableArray array];
    [self flattenDescendantForNode:self to:result];
    return result;
}

- (NSArray *)ancestor {
    NSMutableArray *result = [NSMutableArray array];
    [self flattenAncestorForNode:self to:result];
    return result;
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < self.hierarchy.count; ++i) {
        if (i == 0) {
            [string appendString:_hierarchy.firstObject.description];
        } else {
            [string appendString:[NSString stringWithFormat:@"-%@", _hierarchy[i].description]];
        }
    }
    return string;
}

#pragma mark - Utils

- (void)flattenDescendantForNode:(ZXTreeNode *)node to:(NSMutableArray *)result {
    for (ZXTreeNode *child in node.children) {
        [result addObject:child];
        [self flattenDescendantForNode:child to:result];
    }
}

- (void)flattenAncestorForNode:(ZXTreeNode *)node to:(NSMutableArray *)result {
    if (node.parent) {
        [result addObject:node.parent];
        [self flattenAncestorForNode:node.parent to:result];
    }
}

- (void)flattenHierarchyForNode:(ZXTreeNode *)node to:(NSMutableArray *)result {
    if (node.parent) {
        NSInteger indexInSiblings = [node.parent.children indexOfObject:node];
        [result insertObject:@(indexInSiblings) atIndex:0];
        [self flattenHierarchyForNode:node.parent to:result];
    } else {
        // root node
        [result insertObject:node.hierarchy.firstObject atIndex:0];
    }
}

@end
