//
//  main.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/6.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}


//int main()
//{
//    __block int intValue = 0;
//    void (^blk)(void) = ^{
//        intValue = 1;
//    };
//    return 0;
//}
