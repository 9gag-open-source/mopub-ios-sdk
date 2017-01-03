//
//  MPGoogleAdMobCustomEvent.h
//  9GAG
//
//  Created by Jacky Wang on 6/5/2016.
//  Copyright © 2016 9GAG. All rights reserved.
//

#import "MPNativeCustomEvent.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MPGoogleAdMobCustomEvent : MPNativeCustomEvent<GADAdLoaderDelegate, GADNativeContentAdLoaderDelegate, GADNativeAppInstallAdLoaderDelegate>

@end
