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

#define COUBR_BASE_URL @"https://api.coubr.de"
#define TIMEOUT_INTERVAL_FOR_REQUEST (10) // seconds

#define LEGAL_URL @"http://coubr.de/static/pages/legal/legal-ios.html"
#define HELP_URL @"http://coubr.de/static/pages/help/help-ios.html"

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

#define EXPLORE_URL @"https://api.coubr.de/explore"
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
#define EXPLORE_RESPONSE_STORE_COUPONS @"oc"
#define EXPLORE_RESPONSE_STORE_STAMPCARDS @"oc"
#define EXPLORE_RESPONSE_STORE_SPECIALOFFERS @"oc"

// Store

#define STORE_BASE_URL @"https://api.coubr.de/store"

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
#define STORE_RESPONSE_STORE_WEBSITE @"cw"
#define STORE_RESPONSE_STORE_COUPONS @"co"
#define STORE_RESPONSE_STORE_STAMP_CARDS @"co"
#define STORE_RESPONSE_STORE_SPECIAL_OFFERS @"co"

#define STORE_RESPONSE_COUPON_ID @"i"
#define STORE_RESPONSE_COUPON_TITLE @"t"
#define STORE_RESPONSE_COUPON_DESCRIPTION @"d"
#define STORE_RESPONSE_COUPON_CATEGORY @"c"
#define STORE_RESPONSE_COUPON_VALID_TO @"v"
#define STORE_RESPONSE_COUPON_AMOUNT @"a"
#define STORE_RESPONSE_COUPON_AMOUNT_REDEEMED @"ar"

#define STORE_RESPONSE_STAMP_CARD_ID @"i"
#define STORE_RESPONSE_STAMP_CARD_TITLE @"t"
#define STORE_RESPONSE_STAMP_CARD_DESCRIPTION @"d"
#define STORE_RESPONSE_STAMP_CARD_CATEGORY @"c"
#define STORE_RESPONSE_STAMP_CARD_VALID_TO @"v"
#define STORE_RESPONSE_STAMP_CARD_STAMPS @"s"

#define STORE_RESPONSE_SPECIAL_OFFER_ID @"i"
#define STORE_RESPONSE_SPECIAL_OFFER_TITLE @"t"
#define STORE_RESPONSE_SPECIAL_OFFER_DESCRIPTION @"d"
#define STORE_RESPONSE_SPECIAL_OFFER_CATEGORY @"c"
#define STORE_RESPONSE_SPECIAL_OFFER_VALID_FROM @"vf"
#define STORE_RESPONSE_SPECIAL_OFFER_VALID_TO @"vt"
#define STORE_RESPONSE_SPECIAL_OFFER_SHORT_DESCRIPTION @"sd"

// Redeem

#define COUPON_BASE_URL @"https://api.coubr.de/coupon/"
#define COUPON_REDEEM_URL @"redeem"

// Search

//#define GOOGLE_GEOCODE_URL @"https://maps.googleapis.com/maps/api/geocode/json?"
//#define GOOGLE_GEOCODE_ADDRESS_QUERY @"address="
//#define GOOGLE_GEOCODE_KEY_QUERY @"key="
//#define GOOGLE_GEOCODE_KEY @"AIzaSyCtXyICtACo_Y5vxCT134scRSpBz7H6RIY"

// Social Media Links
#define FEEDBACK_EMAIL @"feedback@coubr.de"

#define APPSTORE_ID @"00000000"
#define APPSTORE_LINK @"itms-apps://itunes.apple.com/app/00000000"

#define TWITTER_APP_LINK @"twitter://user?screen_name=coubrapp"
#define FACEBOOK_APP_LINK @"fb://profile/301895083335756"

#define TWITTER_LINK @"twitter.com/coubrapp"
#define FACEBOOK_LINK @"facebook.com/coubrapp"




