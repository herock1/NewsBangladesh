//
//  NBPreference.h
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const NBBaseURL = @"http://www.newsbangladesh.com/";
static NSString * const NBNews_BanglaURL = @"api/index/";
static NSString * const NBNews_EnglishURL = @"english/api/index/";
static NSString * const NBNewsByCategory_BanglaURL = @"api/catcontent/";
static NSString * const NBNewsByCategory_EnglishURL = @"english/api/catcontent/";
static NSString * const NBNewsImageBaseURL = @"media/imgAll/";
static NSString * const NBMostEmailedBangla=@"http://www.newsbangladesh.com/api/mostemailed/";
static NSString * const NBMOstSharedBangla=@"http://www.newsbangladesh.com/api/mostpopular/";
static NSString * const NBMOstEmailedEnglish=@"http://www.newsbangladesh.com/english/api/mostemailed/";
static NSString * const NBMOstSharedEnglish=@"http://www.newsbangladesh.com/english/api/mostpopular/";


typedef enum {
  
    LanguageModeBangla = 0,
    LanguageModeEnglish
} NBLanguageMode;

@interface NBPreference : NSObject

+ (void)setFontSize:(CGFloat)fontSize;
+ (CGFloat)fontSize;

+ (UIFont *)fontForHeadingLabel;
+ (UIFont *)fontForBodyLabel;

+ (void)setLanguageMode:(NBLanguageMode) mode;
+ (NBLanguageMode)languageMode;

+ (void)setBreakingNewsAlert:(BOOL)yes;
+ (BOOL)breakingNewsAlert;

+ (void)setAutomaticRefresh:(BOOL)yes;
+ (BOOL)automaticRefresh;
+ (NSString *)deviceUUID;
+ (void)sendDeviceToken;
@end
