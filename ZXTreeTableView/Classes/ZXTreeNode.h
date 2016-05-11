//
//  ZXTreeNode.h
//  ZXTreeTableView
//
//  Created by Zinc on 16/5/10.
//  Copyright © 2016年 Zinc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXTreeNode : NSObject

/**
 *  if is expanded
 */
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

/**
 *  children nodes
 */
@property (nonatomic, strong) NSArray<ZXTreeNode *> *children;

/**
 *  parent node
 */
@property (nonatomic, weak) ZXTreeNode *parent;

/**
 *  if true, when the node is expanded, all sibling nodes will be folded
 */
@property (nonatomic, assign) BOOL shouldExclusiveExpand;

/**
 *  array of numbers representing the hierarchy of the node
 *  e.g @[1, 2] says the node is the third child of its parent while its parent is the second root node 
 */
@property (nonatomic, strong) NSArray<NSNumber *> *hierarchy;

@end
