//
//  ViewController.m
//  TuneSoomla
//
//  Created by John Gu on 7/1/15.
//  Copyright © 2015 John Gu. All rights reserved.
//

#import "ViewController.h"
#import "SoomlaProfile.h"
#import "ProfileEventHandling.h"
#import "UserProfile.h"
#import "UserProfileUtils.h"
#import "MarketItem.h"
#import "PurchasableVirtualItem.h"
#import "PurchaseWithMarket.h"
#import "SoomlaStore.h"
#import "StoreEventHandling.h"
#import "StoreInfo.h"
#import "ExampleAssets.h"
#import <MobileAppTracker/MobileAppTracker.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinished:) name:EVENT_UP_LOGIN_FINISHED object:nil];
    // Listen for Soomla EVENT_MARKET_PURCHASED event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(marketPurchased:)
                                                 name:EVENT_MARKET_PURCHASED object:nil];
    
    NSDictionary* providerParams = @{ @(FACEBOOK) :
                                          @{ @"permissions": @"public_profile,user_friends" },
                                      @(TWITTER) :
                                          @{ @"consumerKey": @"[YOUR CONSUMER KEY]",
                                             @"consumerSecret": @"[YOUR CONSUMER SECRET]" },
                                      @(GOOGLE) :
                                          @ {@"clientId": @"[YOUR CLIENT ID"} };
    [[SoomlaProfile getInstance] initialize:providerParams];
    
    [[SoomlaStore getInstance] initializeWithStoreAssets:[[ExampleAssets alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fbButtonTouched:(id)sender {
    [[SoomlaProfile getInstance] loginWithProvider:FACEBOOK];
}

- (IBAction)googleButtonTouched:(id)sender {
    [[SoomlaProfile getInstance] loginWithProvider:GOOGLE];
}

- (IBAction)twitterButtonTouched:(id)sender {
    [[SoomlaProfile getInstance] loginWithProvider:TWITTER];
}

- (IBAction)buyButtonTouched:(id)sender {
    PurchasableVirtualItem* pvi = [[StoreInfo getInstance] purchasableItemWithProductId:@"your_product_id"];
    PurchaseWithMarket* pt = (PurchaseWithMarket*)pvi.purchaseType;
    [[SoomlaStore getInstance] buyInMarketWithMarketItem:pt.marketItem andPayload:@"your_payload"];
}

- (void)loginFinished:(NSNotification*)notification {
    // TODO: extract user profile object from notification
    // NSDictionary* userInfo = notification.userInfo;
    
    //    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //    if (appDelegate.likeReward.canGive == YES) {
    //        [[SoomlaProfile getInstance] like:TARGET_PROVIDER andPageId:@"The.SOOMLA.Project" andReward:appDelegate.likeReward];
    //    }
    
    UserProfile *userProfile = notification.userInfo[DICT_ELEMENT_USER_PROFILE];
    NSString *userId = [userProfile profileId];
    NSString *provider = [UserProfileUtils providerEnumToString:[userProfile provider]];
    if ([provider isEqualToString:@"facebook"]) {
        [MobileAppTracker setFacebookUserId:userId];
    } else if ([provider isEqualToString:@"google"]) {
        [MobileAppTracker setGoogleUserId:userId];
    } else if ([provider isEqualToString:@"twitter"]) {
        [MobileAppTracker setTwitterUserId:userId];
    } else {
        [MobileAppTracker setUserId:userId];
    }
    [MobileAppTracker measureEventName:MAT_EVENT_LOGIN];
}

// On purchase complete, set purchase info and measure purchase in TUNE
- (void)marketPurchased:(NSNotification *)notification {
    CGFloat revenue;
    NSString *currency;
    NSArray *items;

    MarketItem *item = ((PurchaseWithMarket *)[notification.userInfo[DICT_ELEMENT_PURCHASABLE] purchaseType]).marketItem;
    revenue = (CGFloat)([item marketPriceMicros] / 1000000);
    currency = [item marketCurrencyCode];
        
    // Create event item to store purchase item data
    MATEventItem *eventItem = [MATEventItem eventItemWithName:[item marketTitle]
                                                   attribute1:[item productId]
                                                   attribute2:nil
                                                   attribute3:nil
                                                   attribute4:nil
                                                   attribute5:nil];
    // Add event item to MATItem array in order to pass to TUNE SDK
    items = @[eventItem];
    
    // Get transaction ID and receipt data for purchase validation
    NSDictionary *dict = notification.userInfo[DICT_ELEMENT_EXTRA_INFO];
    NSString *transactionId = dict[@"transactionIdentifier"];
    NSString *receipt = dict[@"receiptBase64"];
    NSData *receiptData = [[NSData alloc] initWithBase64EncodedString:receipt options:1];
    
    // Create a MATEvent with this purchase data
    MATEvent *purchaseEvent = [MATEvent eventWithName:MAT_EVENT_PURCHASE];
    purchaseEvent.revenue = revenue;
    purchaseEvent.currencyCode = currency;
    purchaseEvent.refId = transactionId;
    purchaseEvent.receipt = receiptData;
    purchaseEvent.eventItems = items;
    
    // Measure "purchase" event
    [MobileAppTracker measureEvent:purchaseEvent];
}


@end
