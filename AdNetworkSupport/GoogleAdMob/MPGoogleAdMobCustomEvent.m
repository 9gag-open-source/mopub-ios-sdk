//
//  MPGoogleAdMobCustomEvent.m
//  9GAG
//
//  Created by Jacky Wang on 6/5/2016.
//  Copyright © 2016 9GAG. All rights reserved.
//

#import "MPGoogleAdMobCustomEvent.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MPLogging.h"
#import "MoPub.h"
#import "MPNativeAd.h"
#import "MPGoogleAdMobNativeAdAdapter.h"
#include "TargetConditionals.h"
#import "MPAdConfiguration.h"

@interface MPGoogleAdMobCustomEvent()
@property(nonatomic, strong)GADAdLoader *loader;
@end

@implementation MPGoogleAdMobCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    MPLogInfo(@"MOPUB: requesting AdMob Native Ad");
    
    NSString *adUnitID = [info objectForKey:@"adUnitID"];
    
    if (!adUnitID) {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidAdServerResponse(@"MOPUB: No AdUnitID from GoogleAdMob")];
        return;
    }
    
    self.loader = [[GADAdLoader alloc] initWithAdUnitID:adUnitID rootViewController:nil adTypes:@[kGADAdLoaderAdTypeNativeContent,kGADAdLoaderAdTypeNativeAppInstall] options:nil];
    self.loader.delegate = self;
    GADRequest *request = [GADRequest request];
    
#if (TARGET_OS_SIMULATOR)
    
    request.testDevices = @[ kGADSimulatorID ];
    
#endif
    
    NSNumber *genderInNumFormat = [info objectForKey:kAdConfigGender];
    if (genderInNumFormat != nil) {
        request.gender = [genderInNumFormat integerValue];
    }
    
    NSDate *birthdate = [info objectForKey:kAdConfigBirthdate];
    if (birthdate != nil) {
        request.birthday = birthdate;
    }
    
    CLLocation *location = [[CLLocationManager alloc] init].location;
    if (location) {
        [request setLocationWithLatitude:location.coordinate.latitude
                               longitude:location.coordinate.longitude
                                accuracy:location.horizontalAccuracy];
    }
    
    NSString *contentUrl = [info objectForKey:kAdConfigContentUrl];
    if (contentUrl != nil) {
        request.contentURL = contentUrl;
    }
    
    request.requestAgent = @"MoPub";
    [self.loader loadRequest:request];
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    MPLogDebug(@"MOPUB: Did receive app install ad");
    
    MPGoogleAdMobNativeAdAdapter *adapter = [[MPGoogleAdMobNativeAdAdapter alloc] initWithGADNativeAd:nativeAppInstallAd];
    MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adapter];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (GADNativeAdImage *images in nativeAppInstallAd.images) {
        if(images.imageURL){
            [imageArray addObject:images.imageURL];
        }
    }
    
    [super precacheImagesWithURLs:imageArray completionBlock:^(NSArray *errors) {
        if ([errors count]) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:errors[0]];
        } else {
            [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
        }
    }];
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd
{
    MPLogDebug(@"MOPUB: Did receive nativeAd");

    MPGoogleAdMobNativeAdAdapter *adapter = [[MPGoogleAdMobNativeAdAdapter alloc] initWithGADNativeAd:nativeContentAd];
    MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adapter];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (GADNativeAdImage *images in nativeContentAd.images) {
        if(images.imageURL){
            [imageArray addObject:images.imageURL];
        }
    }
    
    [super precacheImagesWithURLs:imageArray completionBlock:^(NSArray *errors) {
        if ([errors count]) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:errors[0]];
        } else {
            [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
        }
    }];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error
{
    MPLogDebug(@"MOPUB: AdMob ad failed to load with error (customEvent): %@", error.description);
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

@end
