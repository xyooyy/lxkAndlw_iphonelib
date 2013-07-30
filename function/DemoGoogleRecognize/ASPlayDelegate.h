//
//  ASPlayDelegate.h
//  RecordColumnarDisplayComponent
//
//  Created by 于 硕 on 13-6-26.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASPlayDelegate <NSObject>
-(void)receivePlayData :(NSDictionary*)voiceData;
-(void)playComplete;
@end
