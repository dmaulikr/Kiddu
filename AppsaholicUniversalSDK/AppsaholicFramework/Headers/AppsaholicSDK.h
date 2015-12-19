//
//  AppsaholicSDK.h
//  AppsaholicSDK
//
//  Created by abhijeet upadhyay on 30/12/14.
//  Copyright (c) 2014 Perk. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "UIKit/UIkit.h"


typedef void (^InitialiseSDK) (BOOL success, NSString *status);
typedef void (^TrackEvent) (BOOL success , NSString *notificationtext, NSNumber *pointEarned);
typedef void (^FetchNotificationSuccess) (BOOL success, NSNumber *unreadNotification);
typedef void (^SDKStatusChange) (BOOL success, BOOL status);
typedef void (^UserInformation) (BOOL success, NSDictionary *info);


@interface AppsaholicSDK : NSObject{
    
    
}
/**
 A must property to assign to work SDK. SDK needs to know application controller from where it needs to present portal and other options.
 */

@property (strong, nonatomic) UIViewController *appsaholic_rootViewController;

/**
 An optional BOOL property so define if after watching Ad user wants to move to Portal or wants to get back to Application. By default it is set to
 "FALSE" and user will be back to Application.
 */
@property (nonatomic)BOOL appsaholic_moveToPortal;

/**
 Singleton to access instance functions.
 */
+ (id)sharedManager;

/**
 SDK initialisation success call back.
 */

- (void)startSession:(NSString*)appKey withSuccess:(InitialiseSDK)success;

/**
 SDK track event one time tap success call back.
 */
- (void)trackEvent:(NSString*)eventID
         withSubID:(NSString*)subID
  notificationType:(BOOL)custom
    withController:(UIViewController*)eventRootController
       withSuccess:(TrackEvent)success;

/**
 Show Portal with root view controller for point claim purpose
 */
-(void)showPortal;

/**
 Claim Point for custom banner call from the controller you want to show advert.
 */

-(void)claimPoints:(UIViewController*)contextController;

/**
 Fetch unclaimed notification call to know how many notifications you have not claimed so far.
 */
-(void)fetchNotifications:(FetchNotificationSuccess)success;

/**
 Unclaimed notification web page call to claim your unclaimed points.
 */
-(void)claimNotificationPage:(UIViewController*)contextController;

/**
 Change SDK status , Appsaholic SDK on or off
 */
-(void)changeSDKStatus:(SDKStatusChange)success;


/**
 Check if Perk supports a perticular country or not.
 */
-(NSArray*)listSupportedCountries;


/**
 Manual Login Page for Appsaholic users to login to Appsaholic SDK to keep earning Perk Points.
 */
-(void)loginCall:(UIViewController*)contextController;

/**
 Manual Logout from SDK
 */
-(void)logOutCall;


/**
 UserInfoDetail (First Name, Last Name and Total point earned by user)
 */
-(void)getUserInformation:(UserInformation)userInfo;




@end
