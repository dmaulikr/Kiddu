//
//  AppsaholicAds.h
//  AppsaholicSDK
//
//  Created by abhijeet upadhyay on 27/08/15.
//  Copyright (c) 2015 Perk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppsaholicAdServerProtocol<NSObject>

- (void)adLoadedSuccessfully;
- (void)adServerWaterFallStarted;
- (void)adServerWaterFallFail;
- (void)adLoadingFail;
- (void)adDidAppear;
- (void)adDidDisappear;
- (void)adWillDisappear;
- (void)adCompletedSuccessfully;
- (void)adClosedWithoutCompletion;
- (void)adIsTouched;

@end

@interface AppsaholicAds : NSObject


+ (id)sharedManager;
@property(nonatomic,weak)id <AppsaholicAdServerProtocol> adServerDelegate;

/**
 Show advertisement stand alone calls
 */
-(void)showVideoAd:(NSString*)placement_id withContextController:(UIViewController*)adRootController;

-(void)showDisplayAd:(NSString*)placement_id withContextController:(UIViewController*)adRootController;

-(void)showAd:(NSString*)placement_id withContextController:(UIViewController*)adRootController;

-(void)showSurvey:(NSString*)placement_id withContextController:(UIViewController*)adRootController;

@end
