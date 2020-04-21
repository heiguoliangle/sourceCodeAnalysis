//
//  test.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/4/8.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "test.h"
#import <UIKit/UIKit.h>


@interface MyPoint : NSObject
@property(nonatomic,assign) CGPoint x;
@property(nonatomic,assign) CGPoint y;
@end
@implementation MyPoint

@end
@implementation test

- (NSMutableArray *)addPoint:(NSArray <MyPoint *> *)points section:(NSInteger)section {
    if (points.count == 0) {
        return nil;
    }
    CGFloat totalDistance = 0;
    for (int i = 1; i < points.count; i ++) {
        totalDistance += [self caluPointFrom:points[i - 1] to:points[i]];
    }
    
    CGFloat distance = totalDistance / (section * 1.0);
    CGFloat tmpDistance = distance;
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < points.count; i ++) {
        CGFloat currentDistance = [self caluPointFrom:points[i - 1] to:points[i]];
        if (currentDistance >= distance) {
            MyPoint * tmpP = points[i];
            while (currentDistance > distance) {
                tmpP = [self getPointWithFromPoint:tmpP distance:distance];
                distance = tmpDistance;
                currentDistance -= distance;
                [arr addObject:tmpP];
            }
        } else {
            distance -= currentDistance;
        }
    }
    return arr;
}

- (MyPoint *)getPointWithFromPoint:(MyPoint *)point distance:(CGFloat)distance {
    return [MyPoint new];
}

- (CGFloat)caluPointFrom:(MyPoint *)p1 to:(MyPoint *) p2{
    return 20;
}

@end
