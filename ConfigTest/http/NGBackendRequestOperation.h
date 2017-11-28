//
//  NGBackendRequestOperation.h
//  Galaxy
//
//  Created by Eugene Belyakov on 28.05.13.
//  Copyright (c) 2013-2015 Netpulse. All rights reserved.
//

#import "NGCascadeRequestOperation.h"
//TODO move this to separate file
extern NSString* const NGBackendErrorDomain;

extern NSString* const NGBackendResponseDataKey;
extern NSString* const NGBackendResponseSuggestedEmailKey;
extern NSString* const NGBackendResponseMessageKey;
extern NSString* const NGBackendResponseErrorsKey;
extern NSString* const NGBackendResponseErrorCodeKey;

typedef NS_ENUM(NSInteger, NGErrorCode)
{
    NGBackendInternalServerError = 1000,
    NGDuplicateEmailError,
    NGInvalidLoginOrPassword,
    NGDuplicateUserID,
    NGNoActiveGoal,
    NGWorkoutExists,
    NGWrongEmailError,
    NGXidExists,
    NGMultipleMissingWorkouts,
    NGAccoutAlreadyLinked,
    NGOldPasswordInvalid,
    NGNewPasswordMatchesOldPassword,
    NGMemberIDNotFound,
    NGMemberIDNotFirstTime,
    NGEmailNotFound,
    NGMemberIDDuplicated,
    NGInvalidHomeClub,
    NGInvalidLastName,
    NGInvalidEmail,
    NGNewHomeClubRequired,
    NGMemberIDRequired,
    NGMemberIDExpired,
    NGReferAFriendAlreadyDone,
    NGAlreadyAMember,
    NGAlreadyRegistered,
    NGChallengeAlreadyJoined,
    NGChallengeNotJoined,
    NGMembershipNotSetup,
    NGMembershipNotFound,
    NGMembershipInactive,
    NGMembershipConflict,
    NGUserSyncFailedHomeClubRequired,
    NGUserSyncFailedPasswordChangeRequired,

    NGHomeClubUUIDWasEmpty,
    NGHomeClubUUIDWrongFormat,
    NGHomeClubUUIDNotFound,
    NGBarcodeWasEmpty,
    NGBarcodeWrongFormat,
    NGLastNameWasEmpty,
    NGLastNameWrongFormat,
    NGInvalidWeight,
    NGInvalidHeight,

    NGAccountWasBlocked,
    NGGuestPassNotFound,
    NGProfileNotUpgraded,
    NGGuestPassHasActiveMembership,
    NGGuestPassUserAlreadyCreated,
    NGGuestPassUserJustCreated,
    NGStaffEmailIsNotAllowed,

    NGExtendedRewardsReachedCapLimit,
    NGExtendedRewardsOrderNotRedeemable,
    NGExtendedRewardsOrderAlreadyRedeemed,

    NGLocateAccountFailed,
    NGUserSyncFailedEmailChangeRequired,

    NGAppVersionDeprecated,
    NGAccessDenied,
    NGOtherError,

    NGDuplicateInEgym,
    NGEmailMismatch
};


@interface NGBackendRequestOperation : NGCascadeRequestOperation

- (void)updateSessionToken:(NSString*)token;

@end
