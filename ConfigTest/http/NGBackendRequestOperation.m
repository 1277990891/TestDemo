//
//  NGBackendRequestOperation.m
//  Galaxy
//
//  Created by Eugene Belyakov on 28.05.13.
//  Copyright (c) 2013-2015 Netpulse. All rights reserved.
//

#import "NGBackendRequestOperation.h"

NSString* const NGBackendErrorDomain = @"NGBackendErrorDomain";
NSString* const NGBackendResponseDataKey = @"responseData";
NSString* const NGBackendResponseSuggestedEmailKey = @"NGBackendResponseSuggestedEmailKey";
NSString* const NGBackendResponseMessageKey = @"NGBackendResponseMessageEmailKey";
NSString* const NGBackendResponseErrorsKey = @"NGBackendResponseErrorsKey";
NSString* const NGBackendResponseErrorCodeKey = @"NGBackendResponseErrorCodeKey";

@interface NGBackendRequestOperation ()

@property (readwrite, nonatomic, strong) NSURLRequest* request;

@end

@implementation NGBackendRequestOperation

@synthesize request;


- (void)updateSessionToken:(NSString*)token
{
    NSMutableURLRequest* newRequest = [self.request mutableCopy];
    [newRequest setValue:token forHTTPHeaderField:@"Cookie"];
    self.request = newRequest;
}

- (NSError*)error
{
    __block NSError* error = [super error];
    id responseObject = [self responseJSON];

    if (nil != error && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSString* message = SAFE_GET_OBJECT(responseObject, @"message");
        NSString* cause = SAFE_GET_OBJECT(responseObject, @"cause");

        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:@{NGBackendResponseDataKey: responseObject, NGBackendResponseErrorCodeKey: @(self.response.statusCode), NSUnderlyingErrorKey: error}];

        if (nil != message)
        {
            [userInfo addEntriesFromDictionary:@{NGBackendResponseMessageKey: message}];
        }
        else
        {
            id errorsObject = SAFE_GET_OBJECT(responseObject, @"errors");

            if (nil != errorsObject)
            {
                [userInfo addEntriesFromDictionary:@{NGBackendResponseErrorsKey: errorsObject}];
            }
        }

        if (self.response.statusCode == 403 && cause.length > 0)
        {
            if ([cause isEqualToString:@"membershipVerificationFailed.membershipNotSetup"])
            {
                [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"We could not locate you in the system. Please make sure your information is correct or try again in a few minutes. If you joined online, please visit the location to pick up your key tag and then register your account on the app.", @"Error message from backend")}];

                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMembershipNotSetup userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"membershipVerificationFailed.membershipNotFound"])
            {
                [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"We could not locate you in the system. Please make sure your information is correct or try again in a few minutes. If you joined online, please visit the location to pick up your key tag and then register your account on the app.", @"Error message from backend")}];

                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMembershipNotFound userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"membershipVerificationFailed.membershipInactive"])
            {
                [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Sorry our records indicate your membership is inactive. Please make sure your information is correct and try again.", @"Error message from backend")}];

                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMembershipInactive userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"membershipVerificationFailed.membershipConflict"])
            {
                [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: @"We're sorry! Something went wrong. Please try again later."}];

                NSDictionary* data = SAFE_GET_OBJECT(responseObject, @"data");
                NSString* email = SAFE_GET_OBJECT(data, @"email");
                if ([email length] > 0)
                {
                    SAFE_GET_OBJECT(userInfo, email);
                }

                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMembershipConflict userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"membershipVerificationFailed.hasActiveMembership"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGGuestPassHasActiveMembership userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"userSyncFailed.homeClubRequired"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGUserSyncFailedHomeClubRequired userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"userSyncFailed.passwordChangeRequired"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGUserSyncFailedPasswordChangeRequired userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"userSyncFailed.emailChangeRequired"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGUserSyncFailedEmailChangeRequired userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"profileVerificationFailed.profileNotUpgraded"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGProfileNotUpgraded userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"rewardAccessFailed.rewardNotOrderable"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGExtendedRewardsReachedCapLimit userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"rewardAccessFailed.orderNotRedeemable"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGExtendedRewardsOrderNotRedeemable userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"rewardAccessFailed.orderAlreadyRedeemed"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGExtendedRewardsOrderAlreadyRedeemed userInfo:userInfo];
            }
            else
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGOtherError userInfo:userInfo];
            }
        }
        else if (self.response.statusCode == 401 && (nil != message))
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"The data you entered is incorrect. Please try again.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGInvalidLoginOrPassword userInfo:userInfo];
        }
        else if (self.response.statusCode == 404 && [message hasPrefix:@"No active goal found for"])
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No active goal for current user", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGNoActiveGoal userInfo:userInfo];
        }
        else if (self.response.statusCode == 404 && [message hasPrefix:@"No active exerciser found with username"])
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"The xID or email address you entered was not found in our system. Please try again.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGNoActiveGoal userInfo:userInfo];
        }
        else if (self.response.statusCode == 409 && [message hasPrefix:@"Account already linked"])
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"This %@ account is linked with another xID account. Please try again.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGAccoutAlreadyLinked userInfo:userInfo];
        }
        else if (self.response.statusCode == 500 && [message hasPrefix:@"Workout exists"])
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Workout exists.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGNoActiveGoal userInfo:userInfo];
        }
        else if (self.response.statusCode == 500 && [message hasPrefix:@"General Error"] && [[self.response.URL absoluteString] rangeOfString:@"np/exerciser/.*/workout" options:NSRegularExpressionSearch].location != NSNotFound)
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Workout already exists for the same date/time.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGWorkoutExists userInfo:userInfo];
        }
        else if (self.response.statusCode == 404 && [message rangeOfString:@"Member with id .* not found." options:NSRegularExpressionSearch].location != NSNotFound)
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"We could not locate your information, but no worries. Continue to set up your account and earn points. If your club is not participating in the pilot program, your access will be revoked after 4 days.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMemberIDNotFound userInfo:userInfo];
        }
        else if (self.response.statusCode == 403 && ([message rangeOfString:@"Exerciser with id .* is not a first time user" options:NSRegularExpressionSearch].location != NSNotFound || [message rangeOfString:@"Exerciser with email .* is not a first time user" options:NSRegularExpressionSearch].location != NSNotFound))
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMemberIDNotFirstTime userInfo:userInfo];
        }
        else if (self.response.statusCode == 403 && [message rangeOfString:@"Exerciser with email .* already exists" options:NSRegularExpressionSearch].location != NSNotFound)
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGDuplicateEmailError userInfo:userInfo];
        }
        else if (self.response.statusCode == 409 && ([message isEqualToString:@"Email is not unique."] || [message isEqualToString:@"Account with such email already exist"]))
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGDuplicateEmailError userInfo:userInfo];
        }
        else if (self.response.statusCode == 403 && [message isEqualToString:@"Membership expired"])
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMemberIDExpired userInfo:userInfo];
        }
        else if (self.response.statusCode == 403 && [message rangeOfString:@"Exerciser with id .* has different home club." options:NSRegularExpressionSearch].location != NSNotFound)
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGInvalidHomeClub userInfo:userInfo];
        }
        else if (self.response.statusCode == 404 && ([message hasPrefix:@"No home club specified for exerciser with email"] || [message hasPrefix:@"Person with email not found"]))
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGEmailNotFound userInfo:userInfo];
        }
        else if (self.response.statusCode == 404 && [message isEqualToString:@"User not found"])
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGLocateAccountFailed userInfo:userInfo];
        }
        else if (self.response.statusCode == 300)
        {
            NSString* statusString = [[self.response allHeaderFields] objectForKey:@"NP-Description"];

            if ([statusString isEqualToString:@"memberId"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMemberIDRequired userInfo:userInfo];
            }
            else if ([statusString isEqualToString:@"memberId expired"])
            {
                [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"The data you entered is incorrect. Please try again.", @"Error message from backend")}];

                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMemberIDExpired userInfo:userInfo];
            }
            else if ([statusString isEqualToString:@"newHomeClubUuid"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGNewHomeClubRequired userInfo:userInfo];
            }
        }
        else if (self.response.statusCode == 400 && [[[self.response allHeaderFields] objectForKey:@"NP-Description"] isEqualToString:@"memberId duplicated"])
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMemberIDDuplicated userInfo:userInfo];
        }
        else if (self.response.statusCode == 400 && [message isEqualToString:@"They already recommended that person."])
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"You've already sent a referral to the email you submitted.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGReferAFriendAlreadyDone userInfo:userInfo];
        }
        else if (self.response.statusCode == 400 && [message isEqualToString:@"They cannot recommend them self."])
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"Sorry, the email is already associated with a %@ member.", @"Error message from backend"), [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey]]}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGAlreadyAMember userInfo:userInfo];
        }
        else if (self.response.statusCode == 400 && [message isEqualToString:@"Person is already registered"])
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"Sorry, the email is already associated with a %@ member.", @"Error message from backend"), [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey]]}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGAlreadyRegistered userInfo:userInfo];
        }
        else if ((self.response.statusCode == 403) && [message rangeOfString:@"has already joined challenge"].location != NSNotFound)
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Exerciser has already joined challenge.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGChallengeAlreadyJoined userInfo:userInfo];
        }
        else if ((self.response.statusCode == 403) && [message rangeOfString:@"has not joined challenge"].location != NSNotFound)
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Exerciser has not joined challenge.", @"Error message from backend")}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGChallengeNotJoined userInfo:userInfo];
        }
        else if (self.response.statusCode == 404 && [message hasPrefix:@"GuestPass not found for exerciser"])
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGGuestPassNotFound userInfo:userInfo];
        }
        else if (self.response.statusCode == 500)
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: @"We're sorry! Something went wrong. Please try again later."}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGBackendInternalServerError userInfo:userInfo];
        }
        else if (self.response.statusCode == 403)
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGAccessDenied userInfo:userInfo];
        }
        else if (self.response.statusCode == 423 && [cause isEqualToString:@"deprecatedAppVersionFailure.deprecatedAppVersion"])
        {
            error = [NSError errorWithDomain:NGBackendErrorDomain code:NGAppVersionDeprecated userInfo:userInfo];
        }
        else if (self.response.statusCode == 409)
        {
            if ([cause isEqualToString:@"duplicationError.userAlreadyCreated"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGGuestPassUserAlreadyCreated userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"duplicationError.userJustCreated"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGGuestPassUserJustCreated userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"duplicationError.staffEmailIsNotAllowed"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGStaffEmailIsNotAllowed userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"duplicationError.duplicateInEgym"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGDuplicateInEgym userInfo:userInfo];
            }
            else if ([cause isEqualToString:@"membershipUpgradeException.emailMismatch"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGEmailMismatch userInfo:userInfo];
            }
            else
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGOtherError userInfo:userInfo];
            }
        }
        else if (message != nil)
        {
            [userInfo addEntriesFromDictionary:@{NSLocalizedDescriptionKey: message}];

            error = [NSError errorWithDomain:NGBackendErrorDomain code:error.code userInfo:userInfo];
        }
        else
        {
            NSDictionary* errors = responseObject[@"errors"];
            [errors enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* value, BOOL* stop) {
                NSError* newError = [self errorForKey:key value:value underlyingError:error baseUserInfo:userInfo];
                if (nil != newError)
                {
                    error = newError;
                    *stop = YES;
                }
            }];
        }
    }
    else if (nil == error && [responseObject isKindOfClass:[NSDictionary class]])
    {
        // Specific error handling used with endpoint /np/exerciser/validate
        // Backend implmentation performs additional checks after completing validation. The result of these additional checks is reported within message.

        NSString* status = SAFE_GET_OBJECT(responseObject, @"status");

        if ([status isEqualToString:@"found"])
        {
            NSDictionary* messages = SAFE_GET_OBJECT(responseObject, @"messages");

            NSString* clientLoginIdState = SAFE_GET_OBJECT(messages, @"clientLoginId");
            NSString* emailState = SAFE_GET_OBJECT(messages, @"email");

            if ([clientLoginIdState isEqualToString:@"duplicate"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGMemberIDDuplicated userInfo:@{NSLocalizedDescriptionKey: @"Member ID duplicated", NGBackendResponseErrorsKey: @{@"clientLoginId": @"duplicate"}}];
            }
            else if ([emailState isEqualToString:@"duplicate"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGDuplicateEmailError userInfo:@{NSLocalizedDescriptionKey: @"Email duplicated", NGBackendResponseErrorsKey: @{@"email": @"duplicate"}}];
            }
            else if ([emailState isEqualToString:@"noPassword"])
            {
                error = [NSError errorWithDomain:NGBackendErrorDomain code:NGDuplicateEmailError userInfo:@{NSLocalizedDescriptionKey: @"Email duplicated", NGBackendResponseErrorsKey: @{@"email": @"noPassword"}}];
            }
        }
    }
    else if (nil != error && self.response.statusCode == 500)
    {
        NSDictionary* userInfo = @{NGBackendResponseErrorCodeKey: @(self.response.statusCode), NSLocalizedDescriptionKey: @"We're sorry! Something went wrong. Please try again later.", NSUnderlyingErrorKey: error};

        error = [NSError errorWithDomain:NGBackendErrorDomain code:NGBackendInternalServerError userInfo:userInfo];
    }

    return error;
}

- (NSError*)errorForKey:(NSString*)key value:(NSString*)value underlyingError:(NSError*)underlyingError baseUserInfo:(NSDictionary*)baseUserInfo
{
    NSInteger errorCode = NGOtherError;
    NSString* localizedDescription = underlyingError.localizedDescription;

    if ([key isEqualToString:@"email"] && [value isEqualToString:@"duplicate"])
    {
        errorCode = NGDuplicateEmailError;
        localizedDescription = NSLocalizedString(@"This email is already registered.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"email"] && [value isEqualToString:@"Wrong email format"])
    {
        errorCode = NGWrongEmailError;
        localizedDescription = NSLocalizedString(@"This email format is not supported by Perkville. Please try another one.", @"Wrong email format message");
    }
    else if ([key isEqualToString:@"clientLoginId"] && [value isEqualToString:@"duplicate"])
    {
        errorCode = NGDuplicateUserID;
        localizedDescription = NSLocalizedString(@"The User ID you have entered is already taken. Please try again.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"birthday"] && [value isEqualToString:@"invalidOrUnderage"])
    {
        errorCode = NGDuplicateUserID;
        localizedDescription = NSLocalizedString(@"Birthday is invalid or underage.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"passcode"] && [value isEqualToString:@"invalidPasscode"])
    {
        errorCode = NGDuplicateUserID;
        localizedDescription = NSLocalizedString(@"The passcode you have entered is invalid. Please try again.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"workoutDateTime"] && ([value isEqualToString:@"future"] || [value isEqualToString:@"invalid"]))
    {
        errorCode = NGDuplicateUserID;
        localizedDescription = NSLocalizedString(@"Enter a date within 4 weeks prior to today's date.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"workoutDate"] && [value isEqualToString:@"less24HrSinceAdded"])
    {
        errorCode = NGMultipleMissingWorkouts;
        localizedDescription = NSLocalizedString(@"You can report only one missing workout per day.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"oldPassword"] && [value isEqualToString:@"invalid"])
    {
        errorCode = NGOldPasswordInvalid;
        localizedDescription = NSLocalizedString(@"The passcode you have entered is incorrect. Please try again.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"newPassword"] && [value isEqualToString:@"newPasswordMatchesOldPassword"])
    {
        errorCode = NGNewPasswordMatchesOldPassword;
        localizedDescription = NSLocalizedString(@"New password can not be the same as the old one", @"Valiation message");
    }
    else if ([key isEqualToString:@"lastName"] && [value isEqualToString:@"doesNotMatchAbc"])
    {
        errorCode = NGInvalidLastName;
        localizedDescription = NSLocalizedString(@"Last name does not match the user associated with the barcode.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"email"] && [value isEqualToString:@"wrongFormat"])
    {
        errorCode = NGInvalidEmail;
        localizedDescription = NSLocalizedString(@"Enter email address up to 64 characters.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"homeClubUuid"] && [value isEqualToString:@"wasEmpty"])
    {
        errorCode = NGHomeClubUUIDWasEmpty;
    }
    else if ([key isEqualToString:@"homeClubUuid"] && [value isEqualToString:@"wrongFormat"])
    {
        errorCode = NGHomeClubUUIDWrongFormat;
    }
    else if ([key isEqualToString:@"homeClubUuid"] && [value isEqualToString:@"notFound"])
    {
        errorCode = NGHomeClubUUIDNotFound;
    }
    else if ([key isEqualToString:@"barcode"] && [value isEqualToString:@"wasEmpty"])
    {
        errorCode = NGBarcodeWasEmpty;
    }
    else if ([key isEqualToString:@"barcode"] && [value isEqualToString:@"wrongFormat"])
    {
        errorCode = NGBarcodeWrongFormat;
    }
    else if ([key isEqualToString:@"lastName"] && [value isEqualToString:@"wasEmpty"])
    {
        errorCode = NGLastNameWasEmpty;
    }
    else if ([key isEqualToString:@"lastName"] && [value isEqualToString:@"wrongFormat"])
    {
        errorCode = NGLastNameWrongFormat;
    }
    else if ([key isEqualToString:@"weight"] && [value isEqualToString:@"invalid"])
    {
        errorCode = NGInvalidWeight;
        localizedDescription = NSLocalizedString(@"Weight value is outside of allowed range.", @"Error message from backend");
    }
    else if ([key isEqualToString:@"height"] && [value isEqualToString:@"invalid"])
    {
        errorCode = NGInvalidHeight;
        localizedDescription = NSLocalizedString(@"Height value is outside of allowed range.", @"Error message from backend");
    }

    NSDictionary* userInfo = baseUserInfo;

    if (nil != localizedDescription && nil != userInfo)
    {
        NSMutableDictionary* updateUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];

        updateUserInfo[NSLocalizedDescriptionKey] = localizedDescription;

        userInfo = updateUserInfo;
    }

    return [NSError errorWithDomain:NGBackendErrorDomain code:errorCode userInfo:userInfo];
}

@end
