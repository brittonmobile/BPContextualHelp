// BPContextualHelpViewController.h
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

#import <UIKit/UIKit.h>

typedef void (^BPViewControllerParameterlessBlock)();
typedef void (^BPViewControllerBooleanBlock)(BOOL);
typedef BOOL (^BPViewControllerShouldAutorotateBlock)(UIInterfaceOrientation);
typedef void (^BPViewControllerWillAnimateRotationBlock)(UIInterfaceOrientation, NSTimeInterval);
typedef id (^BPViewControllerAccessibilityElementAtIndexBlock)(NSInteger);
typedef NSInteger (^BPViewControllerAccessibilityElementCountBlock)();
typedef NSInteger (^BPViewControllerIndexOfAccessibilityElementBlock)(id);

@interface BPContextualHelpViewController : UIViewController

@property (nonatomic, copy) BPViewControllerParameterlessBlock loadViewBlock;

@property (nonatomic, copy) BPViewControllerParameterlessBlock viewDidLoadBlock;
@property (nonatomic, copy) BPViewControllerParameterlessBlock viewWillUnloadBlock;
@property (nonatomic, copy) BPViewControllerParameterlessBlock viewDidUnloadBlock;

@property (nonatomic, copy) BPViewControllerParameterlessBlock didReceiveMemoryWarningBlock;

@property (nonatomic, copy) BPViewControllerBooleanBlock viewWillAppearBlock;
@property (nonatomic, copy) BPViewControllerBooleanBlock viewDidAppearBlock;
@property (nonatomic, copy) BPViewControllerBooleanBlock viewWillDisappearBlock;
@property (nonatomic, copy) BPViewControllerBooleanBlock viewDidDisappearBlock;

@property (nonatomic, copy) BPViewControllerParameterlessBlock viewDidLayoutSubviewsBlock;

@property (nonatomic, copy) BPViewControllerShouldAutorotateBlock shouldAutorotateBlock;
@property (nonatomic, copy) BPViewControllerWillAnimateRotationBlock willAnimateRotationBlock;

@property (nonatomic, copy) BPViewControllerParameterlessBlock updateViewConstraintsBlock;
@property (nonatomic, copy) BPViewControllerAccessibilityElementAtIndexBlock accessibilityElementAtIndexBlock;
@property (nonatomic, copy) BPViewControllerAccessibilityElementCountBlock accessibilityElementCountBlock;
@property (nonatomic, copy)  BPViewControllerIndexOfAccessibilityElementBlock indexOfAccessibilityElementBlock;

+ (instancetype)viewController;

@end
