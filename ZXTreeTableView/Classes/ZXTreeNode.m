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
        [self flattenParentForNode:self to:result];
        _hierarchy = result;
    }
    return _hierarchy;
}

- (void)flattenParentForNode:(ZXTreeNode *)node to:(NSMutableArray *)result {
    if (node.parent) {
        NSInteger indexInSiblings = [node.parent.children indexOfObject:node];
        [result insertObject:@(indexInSiblings) atIndex:0];
        [self flattenParentForNode:node.parent to:result];
    } else {
        // root node
        [result insertObject:node.hierarchy.firstObject atIndex:0];
    }
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

@end
