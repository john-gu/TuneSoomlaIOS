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
 an Enumaration listing all the social actions which are supported
 */
typedef enum {
    UPDATE_STATUS = 0,
    UPDATE_STORY = 1,
    UPLOAD_IMAGE = 2,
    GET_CONTACTS = 3,
    GET_FEED = 4
} SocialActionType;

/**
 Utility methods
 */
@interface SocialActionUtils : NSObject

/**
 Maps an action enum to its corresponding string
 
 @param actionType The action enum to map
 @return A string representing the action enum
 */
+ (NSString *)actionEnumToString:(SocialActionType)actionType;
+ (NSString *)actionNumberToString:(NSNumber*)actionNumber;

/**
 Maps an action string to its corresponding enum value
 
 @param actionTypeString The action string to map
 @return An enum representing the action string
 */
+ (SocialActionType)actionStringToEnum:(NSString *)actionTypeString;

@end