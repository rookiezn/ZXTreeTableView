//
//  ZXTreeTableView.h
//  ZXTreeTableView
//
//  Created by Zinc on 16/5/10.
//  Copyright © 2016年 Zinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXTreeNode.h"

@class ZXTreeTableView;

@protocol ZXTreeTableViewDelegate <NSObject>

@required

/**
 *  ask the delegate for the cell according to the treeTableView and tree node
 *
 *  @param treeTableView treeTableView
 *  @param node          node
 *
 *  @return cell for the treeTableView at the node
 */
- (UITableViewCell *)zxTreeTableView:(ZXTreeTableView *)treeTableView cellAtNode:(ZXTreeNode *)node;

/**
 *  ask the delegate for root nodes of the treeTableView
 *
 *  @param treeTableView treeTableView
 *
 *  @return array of ZXTreeNode
 */
- (NSArray *)rootNodesForZXTreeTableView:(ZXTreeTableView *)treeTableView;

@optional

/**
 *  ask the delegate for the cell height correspond to the node
 *
 *  @param treeTableView treeTableView
 *  @param node          node
 *
 *  @return cell height
 */
- (CGFloat)zxTreeTableView:(ZXTreeTableView *)treeTableView heightForNode:(ZXTreeNode *)node;

/**
 *  inform the delegate that the cell correspond to the node was selected
 *
 *  @param treeTableView treeTableView
 *  @param node          node
 */
- (void)zxTreeTableView:(ZXTreeTableView *)treeTableView didSelectNode:(ZXTreeNode *)node;

@end


@interface ZXTreeTableView : UITableView

@property (nonatomic, weak) id<ZXTreeTableViewDelegate> zxTreeTableViewDelegate;

/**
 *  get indexPath according to the node
 *
 *  @param node node
 *
 *  @return indexPath
 */
- (NSIndexPath *)indexPathForNode:(ZXTreeNode *)node;

/**
 *  get tree node according to indexPath
 *
 *  @param indexPath indexPath
 *
 *  @return tree node
 */
- (ZXTreeNode *)nodeForIndexPath:(NSIndexPath *)indexPath;

/**
 *  toggle tree node
 *
 *  @param node     node
 *  @param animated with animation or not
 */
- (void)toggleNode:(ZXTreeNode *)node animated:(BOOL)animated;

/**
 *  get a reusable cell according to ZXTreeNode
 *
 *  @param identifier identifier
 *  @param node       node
 *
 *  @return cell
 */
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forNode:(ZXTreeNode *)node;

@end
