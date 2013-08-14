//
//  HistoryViewController.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-7.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "HistoryViewController.h"
#import "CurrentDataViewController.h"

@interface HistoryViewController ()
{
    NSMutableArray *historyRecord;
}
@end

@implementation HistoryViewController

#pragma mark- 获得.data文件

- (BOOL)getExtendNamedataSet :(NSMutableArray*)fileNameSet
{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (NSString *fileName in fileNameSet)
    {
        if([fileName rangeOfString:@".data"].location == NSNotFound)
            [temp addObject:fileName];
    }
    for (NSString *fileName in temp)
    {
        [fileNameSet removeObject:fileName];
    }
    return YES;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSFileManager *manger = [NSFileManager defaultManager];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *fileNameSet = [manger subpathsAtPath:docDir];
        historyRecord = [NSMutableArray arrayWithArray:fileNameSet];
        [self getExtendNamedataSet:historyRecord];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // [self.navigationItem setBackBarButtonItem:leftbtn];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historyRecord count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[[historyRecord objectAtIndex:[historyRecord count]-1-indexPath.row] componentsSeparatedByString:@"."] objectAtIndex:0];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}
 


// Override to support conditional editing of the table view.
/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 */



// Override to support editing the table view.
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
 */


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileName = [fileName stringByAppendingString:@".data"];
    doc = [doc stringByAppendingPathComponent:fileName];
    NSDictionary *recordDict = [NSDictionary dictionaryWithContentsOfFile:doc];
    NSEnumerator *enumerator = [recordDict keyEnumerator];
    NSMutableArray *record = [[NSMutableArray alloc]init];
    
    for (NSNumber *key in enumerator)
    {
        [record addObject:[recordDict objectForKey:key]];
    }
    
    CurrentDataViewController *currentDataController = [[CurrentDataViewController alloc]initWithData:record];
    [self.navigationController pushViewController:currentDataController animated:YES];
}

@end
