//
//  CurrentDataViewController.h
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-6.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentDataViewController : UITableViewController
{
    NSArray *recognizedData;
}
- (id)initWithData :(NSArray*)data;
@end
