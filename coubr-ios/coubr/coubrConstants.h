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

// Error

#define COUBR_ERROR_CODE @"code"

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

// Store

#define STORE_BASE_URL @"https://192.168.2.10:8443/coubr-0.1/a/store"

// TODO

// Social Media Links

#define APPSTORE_ID @"00000000"
#define APPSTORE_LINK @"itms-apps://itunes.apple.com/app/00000000"

#define TWITTER_APP_LINK @"twitter://user?screen_name=coubr"
#define FACEBOOK_APP_LINK @"facebook://coubr"

#define TWITTER_LINK @"twitter.com/coubr"
#define FACEBOOK_LINK @"facebook.com/coubr"