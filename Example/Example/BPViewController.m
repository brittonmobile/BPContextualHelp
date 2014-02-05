// BPViewController.m
//
// Copyright (c) 2014 Britton Mobile Development (http://brittonmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BPViewController.h"

#import "BPContextualHelp.h"

@interface BPViewController ()

@property (nonatomic, strong) UIButton *showButton;

@end

@implementation BPViewController

- (void)loadView
{
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.showButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.showButton setTitle:@"Show Annotations" forState:UIControlStateNormal];
	[self.showButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[self.showButton addTarget:self action:@selector(showAnnotations:) forControlEvents:UIControlEventTouchUpInside];
	[self.showButton sizeToFit];
	self.showButton.frame = CGRectMake(50 - CGRectGetMidX(self.showButton.bounds), 50 - CGRectGetMidY(self.showButton.bounds), CGRectGetWidth(self.showButton.bounds), CGRectGetHeight(self.showButton.bounds));
	self.showButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
	[self.view addSubview:self.showButton];
}

#pragma mark -
#pragma mark UI

- (IBAction)showAnnotations:(id)sender
{
	NSArray *annotations = @[
									 [[BPHelpAnnotation alloc] initWithDirection:BPHelpAnnotationDirectionBottom anchorView:self.showButton contentOffset:CGSizeZero andText:@"This annotation is anchored to a view."],
									 [[BPHelpAnnotation alloc] initWithDirection:BPHelpAnnotationDirectionLeft landscapeAnchorPoint:CGPointMake(50.0, 50.0) portraitAnchorPoint:CGPointMake(50.0, 70.0) contentOffset:CGSizeZero andText:@"This annotation is anchored to one point in landscape and a different one in portrait."],
									 [[BPHelpAnnotation alloc] initWithDirection:BPHelpAnnotationDirectionTop anchorView:self.showButton contentOffset:CGSizeMake(50.0, 0.0) andText:@"This annotation is offset to the right."],
									 //[[BPHelpTapAnnotation alloc] initWithDirection:BPHelpAnnotationDirectionNone landscapeAnchorPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)) portraitAnchorPoint:CGPointMake(CGRectGetMidY(self.view.bounds), CGRectGetMidX(self.view.bounds)) contentOffset:CGSizeZero andText:nil]
									 [[BPHelpTapAnnotation alloc] initWithDirection:BPHelpAnnotationDirectionNone anchorView:self.showButton contentOffset:CGSizeMake(-90.0, 40.0) andText:nil]
									 ];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		annotations = [annotations arrayByAddingObjectsFromArray:@[
																					  [[BPHelpDisclosureAnnotation alloc] initWithDirection:BPHelpAnnotationDirectionNone landscapeAnchorPoint:CGPointMake(904.0, 374.0) portraitAnchorPoint:CGPointMake(648.0, 502.0) contentOffset:CGSizeZero andText:@"This one can be tapped." tapBlock:^{
			NSLog(@"Annotation tapped");
		}]
																					  ]];
	}
	else
	{
		CGFloat longEdge = fmax(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
		CGFloat shortEdge = fmin(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
		
		annotations = [annotations arrayByAddingObjectsFromArray:@[
																					  [[BPHelpDisclosureAnnotation alloc] initWithDirection:BPHelpAnnotationDirectionNone landscapeAnchorPoint:CGPointMake(longEdge / 2, shortEdge - 50.0) portraitAnchorPoint:CGPointMake(shortEdge / 2, longEdge - 50.0) contentOffset:CGSizeZero andText:@"This one can be tapped." tapBlock:^{
			NSLog(@"Annotation tapped");
		}]
																					  ]];
	}
	
	BPHelpOverlayView *helpOverlay = [BPHelpOverlayView helpOverlayViewWithAnnotations:annotations];
	helpOverlay.completionBlock = ^{
		NSLog(@"Use this block to perform an action after the help overlay is hidden");
	};
	[helpOverlay show];
}

@end
