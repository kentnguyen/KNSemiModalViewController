//
//  NSObject+YMOptionsAndDefaults
//  Created by YangMeyer on 08.10.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.
//
@interface NSObject (YMOptionsAndDefaults)
- (void)ym_registerOptions:(NSDictionary *)options
				  defaults:(NSDictionary *)defaults;
- (id)ym_optionOrDefaultForKey:(NSString*)optionKey;
@end
//==================================================================================================


//
// Convenient category method to find actual ViewController that contains a view
//
@interface UIView (FindUIViewController)
- (UIViewController *) containingViewController;
- (id) traverseResponderChainForUIViewController;
@end
//==================================================================================================


//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#define kSemiModalDidShowNotification @"kSemiModalDidShowNotification"
#define kSemiModalDidHideNotification @"kSemiModalDidHideNotification"
#define kSemiModalWasResizedNotification @"kSemiModalWasResizedNotification"

extern const struct KNSemiModalOptionKeys {
	__unsafe_unretained NSString *traverseParentHierarchy; // boxed BOOL. default is YES.
	__unsafe_unretained NSString *pushParentBack;		   // boxed BOOL. default is YES.
	__unsafe_unretained NSString *animationDuration; // boxed double, in seconds. default is 0.5.
	__unsafe_unretained NSString *parentAlpha;       // boxed float. lower is darker. default is 0.5.
    __unsafe_unretained NSString *parentScale;       // boxed double default is 0.8
	__unsafe_unretained NSString *shadowOpacity;     // default is 0.8
	__unsafe_unretained NSString *transitionStyle;	 // boxed NSNumber - one of the KNSemiModalTransitionStyle values.
    __unsafe_unretained NSString *disableCancel;     // boxed BOOL. default is NO.
    __unsafe_unretained NSString *backgroundView;     // UIView, custom background.
} KNSemiModalOptionKeys;

NS_ENUM(NSUInteger, KNSemiModalTransitionStyle) {
	KNSemiModalTransitionStyleSlideUp,
	KNSemiModalTransitionStyleFadeInOut,
	KNSemiModalTransitionStyleFadeIn,
	KNSemiModalTransitionStyleFadeOut,
};

typedef void (^KNTransitionCompletionBlock)(void);

@interface UIViewController (KNSemiModal)

/**
 Displays a view controller over the receiver, which is "dimmed".
 @param vc           The view controller to display semi-modally; its view's frame height is used.
 @param options	     See KNSemiModalOptionKeys constants.
 @param completion   Is called after `-[vc viewDidAppear:]`.
 @param dismissBlock Is called when the user dismisses the semi-modal view by tapping the dimmed receiver view.
 */
-(void)presentSemiViewController:(UIViewController*)vc
					 withOptions:(NSDictionary*)options
					  completion:(KNTransitionCompletionBlock)completion
					dismissBlock:(KNTransitionCompletionBlock)dismissBlock;

-(void)presentSemiView:(UIView*)view
		   withOptions:(NSDictionary*)options
			completion:(KNTransitionCompletionBlock)completion;

// Convenient overloading methods
-(void)presentSemiViewController:(UIViewController*)vc;
-(void)presentSemiViewController:(UIViewController*)vc withOptions:(NSDictionary*)options;
-(void)presentSemiView:(UIView*)vc;
-(void)presentSemiView:(UIView*)view withOptions:(NSDictionary*)options;

// Update (refresh) backgroundView
-(void)updateBackground;
// Dismiss & resize
-(void)resizeSemiView:(CGSize)newSize;
-(void)dismissSemiModalView;
-(void)dismissSemiModalViewWithCompletion:(KNTransitionCompletionBlock)completion;

@end
