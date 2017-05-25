//
//  UIWindow+BPContextualHelp.m
//  Example
//
//  Created by Ryan on 5/24/17.
//  Copyright © 2017 Britton Mobile Development. All rights reserved.
//

#import "UIWindow+BPContextualHelp.h"

@implementation UIWindow (BPContextualHelp)

+ (UIViewController *)bpch_visibleViewControllerFromViewController:(UIViewController *)viewController
{
	if ([viewController isKindOfClass:UINavigationController.class] && ((UINavigationController *) viewController).visibleViewController != nil)
	{
		return [self bpch_visibleViewControllerFromViewController:((UINavigationController *) viewController).visibleViewController];
	}
	else if ([viewController isKindOfClass:UITabBarController.class] && ((UITabBarController *) viewController).selectedViewController != nil)
	{
		return [self bpch_visibleViewControllerFromViewController:((UITabBarController *) viewController).selectedViewController];
	}
	else if (viewController.presentedViewController != nil)
	{
		return [self bpch_visibleViewControllerFromViewController:viewController.presentedViewController];
	}
	
	return viewController;
}

- (UIViewController *)bpch_visibleViewController
{
	if (self.rootViewController != nil)
	{
		return [UIWindow bpch_visibleViewControllerFromViewController:self.rootViewController];
	}
	return nil;
}

@end
