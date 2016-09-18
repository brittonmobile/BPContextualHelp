<p align="center" >
  <img src="https://github.com/brittonmobile/BPContextualHelp/raw/master/assets/annotations.jpg" alt="BPContextualHelp" title="BPContextualHelp">
</p>

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

BPContextualHelp is a custom control based on the contextual help balloons in the pre-iOS 7 iPhoto app. It currently provides three types of annotations: a standard balloon, a balloon with a disclosure indicator, and a circular tap. Full accessibility support is provided for the annotations.

## Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a dependency manager for Objective-C and Swift, which automates and simplifies the process of using 3rd-party libraries in your projects.

### Cartfile

```
github "brittonmobile/BPContextualHelp"
```

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C and Swift, which automates and simplifies the process of using 3rd-party libraries in your projects.

### Podfile

```ruby
platform :ios, '8.0'
pod "BPContextualHelp", "~> 1.0"
```

## Requirements

BPContextualHelp 1.1 requires Xcode 7, targeting iOS 8.0 and above. It supports both ARC and non-ARC projects without requiring special build flags.

## Limitations

Help annotations do not currently account for an offset being too large or for overlapping annotations.

## Usage

Import the header into any file you want to show annotations from:

```objective-c
#import <BPContextualHelp/BPContextualHelp.h>
```

### Show an Annotation

```objective-c
BPHelpAnnotation *annotation = [[BPHelpAnnotation alloc] initWithDirection:BPHelpAnnotationDirectionBottom anchorView:self.aButton contentOffset:CGSizeZero andText:@"This annotation is anchored to a view."];
	
BPHelpOverlayView *helpOverlay = [BPHelpOverlayView helpOverlayViewWithAnnotations:@[annotation]];
helpOverlay.completionBlock = ^{
	NSLog(@"Use this block to perform an action after the help overlay is hidden");
};
[helpOverlay show];
```
