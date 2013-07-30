//
//  ASRecordDelegate.h
//  CyRecord
//
//  Created by 于 硕 on 13-6-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASRecordDelegate <NSObject>
-(void)receiveRecordData :(NSDictionary*)voiceData;
@end
