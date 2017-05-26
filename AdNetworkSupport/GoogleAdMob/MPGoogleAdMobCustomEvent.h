#if __has_include(<MoPub / MoPub.h>)
#import <MoPub/MoPub.h>
#else
#import "MPNativeCustomEvent.h"
#endif

#import <GoogleMobileAds/GoogleMobileAds.h>

// Duplicate to MPGoogleAdMobNativeCustomEvent, since old version is using MPGoogleAdMobCustomEvent and does not have MPGoogleAdMobNativeCustomEvent (config by admin console)
// At this moment please copy the source from MPGoogleAdMobNativeCustomEvent if any changes
@interface MPGoogleAdMobCustomEvent : MPNativeCustomEvent

/// Sets the preferred location of the AdChoices icon.
+ (void)setAdChoicesPosition:(GADAdChoicesPosition)position;

@end
