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

typedef void (^BPCHViewControllerParameterlessBlock)();
typedef void (^BPCHViewControllerBooleanBlock)(BOOL);
typedef BOOL (^BPCHViewControllerShouldAutorotateBlock)(UIInterfaceOrientation);
typedef void (^BPCHViewControllerWillAnimateRotationBlock)(UIInterfaceOrientation, NSTimeInterval);
typedef id (^BPCHViewControllerAccessibilityElementAtIndexBlock)(NSInteger);
typedef NSInteger (^BPCHViewControllerAccessibilityElementCountBlock)();
typedef NSInteger (^BPCHViewControllerIndexOfAccessibilityElementBlock)(id);

@interface BPContextualHelpViewController : UIViewController

@property (nonatomic, copy) BPCHViewControllerParameterlessBlock bpch_loadViewBlock;

@property (nonatomic, copy) BPCHViewControllerParameterlessBlock bpch_viewDidLoadBlock;
@property (nonatomic, copy) BPCHViewControllerParameterlessBlock bpch_viewWillUnloadBlock;
@property (nonatomic, copy) BPCHViewControllerParameterlessBlock bpch_viewDidUnloadBlock;

@property (nonatomic, copy) BPCHViewControllerParameterlessBlock bpch_didReceiveMemoryWarningBlock;

@property (nonatomic, copy) BPCHViewControllerBooleanBlock bpch_viewWillAppearBlock;
@property (nonatomic, copy) BPCHViewControllerBooleanBlock bpch_viewDidAppearBlock;
@property (nonatomic, copy) BPCHViewControllerBooleanBlock bpch_viewWillDisappearBlock;
@property (nonatomic, copy) BPCHViewControllerBooleanBlock bpch_viewDidDisappearBlock;

@property (nonatomic, copy) BPCHViewControllerParameterlessBlock bpch_viewDidLayoutSubviewsBlock;

@property (nonatomic, copy) BPCHViewControllerShouldAutorotateBlock bpch_shouldAutorotateBlock;
@property (nonatomic, copy) BPCHViewControllerWillAnimateRotationBlock bpch_willAnimateRotationBlock;

@property (nonatomic, copy) BPCHViewControllerParameterlessBlock bpch_updateViewConstraintsBlock;
@property (nonatomic, copy) BPCHViewControllerAccessibilityElementAtIndexBlock bpch_accessibilityElementAtIndexBlock;
@property (nonatomic, copy) BPCHViewControllerAccessibilityElementCountBlock bpch_accessibilityElementCountBlock;
@property (nonatomic, copy) BPCHViewControllerIndexOfAccessibilityElementBlock bpch_indexOfAccessibilityElementBlock;

+ (instancetype)bpch_viewController;

@end
