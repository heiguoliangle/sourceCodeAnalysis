//
//  main.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CategoryTest.h"

int main(int argc, char * argv[]) {
    __block int a = 10;

    void(^ b) (void) = ^ {
        a = 11;
    };
    
    a = 12;
    
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
