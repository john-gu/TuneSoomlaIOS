/*
 Copyright (C) 2012-2014 Soomla Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

/**
 an Enumaration listing all the social networks which are supported (or will be)
 NOTE: the numbering is weird to be backwards compatible to previous version,
 see history
 */
typedef enum {
    FACEBOOK = 0,
    GOOGLE = 2,
    TWITTER = 5
} Provider;

/**
 Utility class to help convert `Provider` enum to `NSString` and back
 */
@interface UserProfileUtils : NSObject

/**
 Converts `Provider` enum to a string representation
 
 @param provider The provider value to convert
 @return a String representation if the supplied provider
 @exception NSException when the supplied provider is unspported
 */
+ (NSString *)providerEnumToString:(Provider)provider;
+ (NSString *)providerNumberToString:(NSNumber*)providerNumber;

/**
 Converts the supplied `NSString` to `Provider` if possible
 
 @param providerTypeString The string to convert to `Provider`
 @return The `Provider` value corresponding to the supplied string
 @exception NSException when the supplied string does not have a corresponding
 `Provider` value
 */
+ (Provider)providerStringToEnum:(NSString *)provider;

@end
