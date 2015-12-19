//
//  kAerServConstants.h
//  AerServSDK
//
//  Created by Albert Zhu on 6/5/15.
//  Copyright (c) 2015 AerServ, LLC. All rights reserved.
//

#ifndef AerServSDK_AerServConstants_h
#define AerServSDK_AerServConstants_h

typedef NS_ENUM(NSUInteger, ASEnvironmentType) {
    kASEnvProduction,
    kASEnvStaging,
    kASEnvDevelopment
};

#define kIS_iOS_7_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define kIS_iOS_8_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#endif