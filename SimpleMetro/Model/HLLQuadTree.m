//
//  HLLQuadTree.m
//  One
//
//  Created by Rocky Young on 2017/2/22.
//  Copyright © 2017年 HLL. All rights reserved.
//

#import "HLLQuadTree.h"


#pragma mark -
#pragma mark Structors M

QuadTreeNodeData QuadTreeNodeDataMake(double x,double y,void *data){

    QuadTreeNodeData d;
    d.x = x; d.y = y; d.data = data;
    return d;
}

BoundingBox BoundingBoxMake(double x0,double y0,double xf,double yf){

    BoundingBox box;
    box.x0 = x0; box.y0 = y0; box.xf = xf; box.yf = yf;
    return box;
}

QuadTreeNode* QuadTreeNodeMake(BoundingBox boundary ,int bucketCapacity){

    QuadTreeNode* node = malloc(sizeof(QuadTreeNode));
    node->northEast = NULL;
    node->northWest = NULL;
    node->southEast = NULL;
    node->southWest = NULL;
    
    node->boundingBox = boundary;
    node->bucketCapacity = bucketCapacity;
    node->count = 0;
    node->points = malloc(sizeof(QuadTreeNodeData) * bucketCapacity);
    
    return node;
}


#pragma mark -
#pragma mark BoundingBox M


bool BoundingBoxContainsData(BoundingBox box,QuadTreeNodeData data){
    
    bool containsX = box.x0 <= data.x && data.x <= box.xf;
    bool containsY = box.y0 <= data.y && data.y <= box.yf;
    
    return containsX && containsY;
}


bool BoundingBoxIntersectsBoundingBox(BoundingBox b1,BoundingBox b2){
    
    return (b1.x0 <= b2.xf && b1.xf >= b2.x0 && b1.y0 <= b2.yf && b1.yf >= b2.y0);
}

#pragma mark -
#pragma mark QuadTreeHandle M

QuadTreeNode* QuadTreeBuildWithData(QuadTreeNodeData* data ,int count,BoundingBox boundingBox, int capacity){

    QuadTreeNode * root = QuadTreeNodeMake(boundingBox, capacity);
    for (int i = 0; i < count;i ++) {
        QuadTreeNodeInsertData(root, data[i]);
    }
    return root;
}


bool QuadTreeNodeInsertData(QuadTreeNode* node,QuadTreeNodeData data){

    if (!BoundingBoxContainsData(node->boundingBox, data)) {
        return false;
    }
    
    if (node->count < node->bucketCapacity) {
        node->points[node->count++] = data;
        return true;
    }
    
    if (node->northWest == NULL) {
        QuadTreeNodeSubdivide(node);
    }
    
    if (QuadTreeNodeInsertData(node->northWest, data)) return true;
    if (QuadTreeNodeInsertData(node->northEast, data)) return true;
    if (QuadTreeNodeInsertData(node->southWest, data)) return true;
    if (QuadTreeNodeInsertData(node->southEast, data)) return true;
    
    return false;
}


void QuadTreeNodeSubdivide(QuadTreeNode* node){

    BoundingBox box = node->boundingBox;
    
    double xMid = (box.xf + box.x0) / 2.0;
    double yMid = (box.yf + box.y0) / 2.0;
    
    BoundingBox northWest = BoundingBoxMake(box.x0, box.y0, xMid, yMid);
    node->northWest = QuadTreeNodeMake(northWest, node->bucketCapacity);
    
    BoundingBox northEast = BoundingBoxMake(xMid, box.y0, box.xf, yMid);
    node->northEast = QuadTreeNodeMake(northEast, node->bucketCapacity);
    
    BoundingBox southWest = BoundingBoxMake(box.x0, yMid, xMid, box.yf);
    node->southWest = QuadTreeNodeMake(southWest, node->bucketCapacity);
    
    BoundingBox southEast = BoundingBoxMake(xMid, yMid, box.xf, box.yf);
    node->southEast = QuadTreeNodeMake(southEast, node->bucketCapacity);
}


void QuadTreeGatherDataInRange(QuadTreeNode* node, BoundingBox range, DataReturnBlock block){

    if (!BoundingBoxIntersectsBoundingBox(node->boundingBox, range)) {
        return;
    }
    
    for (int i = 0; i < node->count; i ++) {
        if (BoundingBoxContainsData(range, node->points[i])) {
            block(node->points[i]);
        }
    }
    
    if (node->northWest == NULL) {
        return;
    }
    
    QuadTreeGatherDataInRange(node->northWest, range, block);
    QuadTreeGatherDataInRange(node->northEast, range, block);
    QuadTreeGatherDataInRange(node->southWest, range, block);
    QuadTreeGatherDataInRange(node->southEast, range, block);
}


void FreeQuadTreeNode(QuadTreeNode* node){

    if (node->northEast != NULL) FreeQuadTreeNode(node->northEast);
    if (node->northWest != NULL) FreeQuadTreeNode(node->northWest);
    if (node->southEast != NULL) FreeQuadTreeNode(node->southEast);
    if (node->southWest != NULL) FreeQuadTreeNode(node->southWest);
    
    for (int i = 0; i < node->count; i++) {
        free(node->points[i].data);
    }
    free(node->points);
    free(node);
}

