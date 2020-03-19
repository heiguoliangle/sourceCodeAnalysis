//
//  AppDelegate.m
//  SystemTraceTest
//
//  Created by guoliang hao on 2020/3/17.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "AppDelegate.h"
#import <mach-o/loader.h>
#import <mach-o/dyld.h>

#define  SECOND 1000000
static void add_image_callback (const struct mach_header *mhp,intptr_t slide) {
//    usleep(0.01 * SECOND);
//    printf("动态库加载了");
}

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _dyld_register_func_for_add_image(add_image_callback);
    });
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
