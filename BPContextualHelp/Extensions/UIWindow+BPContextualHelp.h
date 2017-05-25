//
//  UIWindow+BPContextualHelp.h
//  Example
//
//  Created by Ryan on 5/24/17.
//  Copyright © 2017 Britton Mobile Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (BPContextualHelp)

+ (UIViewController *)bpch_visibleViewControllerFromViewController:(UIViewController *)viewController;
- (UIViewController *)bpch_visibleViewController;

@end
