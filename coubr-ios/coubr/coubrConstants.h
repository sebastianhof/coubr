//
//  coubrConstants.h
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#ifndef coubr_coubrConstants_h
#define coubr_coubrConstants_h

#endif

// Notifications

#define LoadInitialDataDidFinishNotification @"LoadInitialDataDidFinishNotification"

// URL Loading

#define COUBR_BASE_URL @"https://192.168.2.10:8443/coubr-0.1/a/"
#define TIMEOUT_INTERVAL_FOR_REQUEST (10) // seconds

#define LEGAL_URL @"legal"
#define HELP_URL @"help"

// Error

#define COUBR_ERROR_CODE @"code"
static int UNKNOWN_ERROR = 1000;
static int JSON_ERROR = 1001;
static int REQUEST_ERROR = 3000;
static int SERVER_ERROR = 5000;

static int STORE_NOT_FOUND_ERROR = 10001;
static int COUPON_CODE_NOT_FOUND_ERROR = 10002;
static int STORE_CODE_NOT_FOUND_ERROR = 10003;

// Explore

#define EXPLORE_URL @"https://192.168.2.10:8443/coubr-0.1/a/explore"
#define EXPLORE_DEFAULT_DISTANCE 10000.0

#define EXPLORE_REQUEST_LATITUDE @"lt"
#define EXPLORE_REQUEST_LONGITUDE @"lg"
#define EXPLORE_REQUEST_DISTANCE @"d"

#define EXPLORE_RESPONSE_STORES @"s"
#define EXPLORE_RESPONSE_STORE_ID @"si"
#define EXPLORE_RESPONSE_STORE_NAME @"sn"
#define EXPLORE_RESPONSE_STORE_TYPE @"st"
#define EXPLORE_RESPONSE_STORE_CATEGORY @"sc"
#define EXPLORE_RESPONSE_STORE_SUBCATEGORY @"ss"
#define EXPLORE_RESPONSE_STORE_LATITUDE @"lt"
#define EXPLORE_RESPONSE_STORE_LONGITUDE @"lg"
#define EXPLORE_RESPONSE_STORE_COUPONS @"c"

#define EXPLORE_RESPONSE_COUPON_ID @"ci"
#define EXPLORE_RESPONSE_COUPON_TITLE @"ct"
#define EXPLORE_RESPONSE_COUPON_STATUS @"cs"

// Store

#define STORE_BASE_URL @"https://192.168.2.10:8443/coubr-0.1/a/store"

#define STORE_RESPONSE_STORE_ID @"i"
#define STORE_RESPONSE_STORE_NAME @"n"
#define STORE_RESPONSE_STORE_DESCRIPTION @"d"
#define STORE_RESPONSE_STORE_TYPE @"t"
#define STORE_RESPONSE_STORE_CATEGORY @"c"
#define STORE_RESPONSE_STORE_SUBCATEGORY @"s"
#define STORE_RESPONSE_STORE_LATITUDE @"lt"
#define STORE_RESPONSE_STORE_LONGITUDE @"lg"
#define STORE_RESPONSE_STORE_STREET @"as"
#define STORE_RESPONSE_STORE_POSTAL_CODE @"ap"
#define STORE_RESPONSE_STORE_CITY @"ac"
#define STORE_RESPONSE_STORE_PHONE @"ct"
#define STORE_RESPONSE_STORE_EMAIL @"ce"
#define STORE_RESPONSE_STORE_COUPONS @"co"

#define STORE_RESPONSE_COUPON_ID @"i"
#define STORE_RESPONSE_COUPON_TITLE @"t"
#define STORE_RESPONSE_COUPON_DESCRIPTION @"d"
#define STORE_RESPONSE_COUPON_CATEGORY @"c"
#define STORE_RESPONSE_COUPON_VALID_TO @"v"
#define STORE_RESPONSE_COUPON_AMOUNT @"a"
#define STORE_RESPONSE_COUPON_AMOUNT_ISSUED @"ai"
#define STORE_RESPONSE_COUPON_STATUS @"s"

// Redeem

#define COUPON_BASE_URL @"https://192.168.2.10:8443/coubr-0.1/a/coupon/"
#define COUPON_REDEEM_URL @"redeem"

// Social Media Links
#define FEEDBACK_EMAIL @"feedback@coubr.de"

#define APPSTORE_ID @"00000000"
#define APPSTORE_LINK @"itms-apps://itunes.apple.com/app/00000000"

#define TWITTER_APP_LINK @"twitter://user?screen_name=coubr"
#define FACEBOOK_APP_LINK @"facebook://coubr"

#define TWITTER_LINK @"twitter.com/coubr"
#define FACEBOOK_LINK @"facebook.com/coubr"




