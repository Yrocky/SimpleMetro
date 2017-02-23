//
//  HLLQuadTree.h
//  One
//
//  Created by Rocky Young on 2017/2/22.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 四叉树的基本数据结构，point、box、node */

// 点也是结构体，因为他们只是用来承载数据的
typedef struct QuadTreeNodeData{
    double x;
    double y;
    void *data;
} QuadTreeNodeData;
QuadTreeNodeData QuadTreeNodeDataMake(double x,double y,void *data);

// 范围仅仅是结构体
typedef struct BoundingBox{
    double x0; double y0;
    double xf; double yf;
} BoundingBox;
BoundingBox BoundingBoxMake(double x0,double y0,double xf,double yf);

// 节点是一个对象
typedef struct QuadTreeNode{
    struct QuadTreeNode* northWest;
    struct QuadTreeNode* northEast;
    struct QuadTreeNode* southWest;
    struct QuadTreeNode* southEast;
    
    BoundingBox boundingBox;
    int bucketCapacity;
    QuadTreeNodeData *points;
    int count;
} QuadTreeNode;
QuadTreeNode* QuadTreeNodeMake(BoundingBox boundary ,int bucketCapacity);


/** 
 建立四叉树
 @param data        用于建树的节点数据指针
 @param count       节点数据的个数
 @param boundingBox 四叉树覆盖的范围
 @param capacity    单节点能容纳的节点数据个数
 @return 四叉树的根节点
 */
QuadTreeNode* QuadTreeBuildWithData(QuadTreeNodeData* data ,int count,BoundingBox boundingBox, int capacity);

/** 
 在四叉树中插入节点数据
 @param node 插入的节点位置
 @param data 需要插入的节点数据
 @return 成功插入返回true，否则false
 */
bool QuadTreeNodeInsertData(QuadTreeNode* node,QuadTreeNodeData data);

/** 
 拆分节点
 */
void QuadTreeNodeSubdivide(QuadTreeNode* node);

/** 
 判断节点数据是否在box范围内
 @param box  box范围
 @param data 节点数据
 @return 若data在box内，返回true，否则false
 */
bool BoundingBoxContainsData(BoundingBox box,QuadTreeNodeData data);

/** 
 判断两box是否相交
 */
bool BoundingBoxIntersectsBoundingBox(BoundingBox b1,BoundingBox b2);


typedef void(^DataReturnBlock)(QuadTreeNodeData data);
void QuadTreeGatherDataInRange(QuadTreeNode* node, BoundingBox range, DataReturnBlock block);


/** 
 清空四叉树
 @param node 四叉数根节点
 */
void FreeQuadTreeNode(QuadTreeNode* node);

