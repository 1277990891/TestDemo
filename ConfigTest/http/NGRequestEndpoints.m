//
//  NGRequestEndpoints.m
//  Galaxy
//
//  Created by Sergey Dunets on 7/22/16.
//  Copyright © 2016 Netpulse. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* const NGMethodSignIn = @"/np/login";
NSString* const NGMethodGetCookies = @"/np/exerciser/goldsgym/get-cookies";
NSString* const NGMethodSignInAsAGuest = @"/np/exerciser/loginAsGuest";
NSString* const NGMethodSignUp = @"/np/exerciser";
NSString* const NGMethodStandardSignIn = @"/np/exerciser/login";
NSString* const NGMethodStandardSignUp = @"/np/exerciser/signUp";
NSString* const NGMethodValidateUserId = @"/np/exerciser/validate";
NSString* const NGMethodLookupByEmail = @"/np/exerciser/validation";
NSString* const NGMethodCheckup = @"/np/exerciser/checkup";
NSString* const NGMethodForgotPasscode = @"/np/exerciser/forgot-passcode";
NSString* const NGMethodForgotPassword = @"/np/exerciser/password-reset";
NSString* const NGMethodChangePassword = @"/np/exerciser/changePassword";
NSString* const NGMethodVerifyMemberID = @"/np/company/%@/exerciser/%@";
NSString* const NGMethodVerifyRetroAbcUser = @"/np/exerciser/abc/%@/validate-membership";
NSString* const NGMethodCreateAbcUserProfile = @"/np/exerciser/abc/%@/create-profile";
NSString* const NGMethodMigrateAbcUserProfile = @"/np/exerciser/abc/%@/migrate-profile";
NSString* const NGMethodFindClub = @"/np/exerciser/company";
NSString* const NGMethodGetClubs = @"/np/company/children";
NSString* const NGPartnerAliasClubCom = @"clubCom";
NSString* const NGMethodPartnerCompanyDetails = @"/np/company/%@/external-details/%@";
NSString* const NGMethodGetProfile = @"/np/exerciser/%@/profile";
NSString* const NGMethodUpdateProfile = @"/np/exerciser/";



