//
//  HistoryViewController.m
//  SpeechRecognition
//
//  Created by xyooyy on 13-8-7.
//  Copyright (c) 2013年 Luwei. All rights reserved.
//

#import "HistoryViewController.h"
#import "Data.h"


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
- (BOOL)setPopViewAction:(id)parmObj :(SEL)parmAction
{
    obj = parmObj;
    popViewAction = parmAction;
    return YES;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        NSFileManager *manger = [NSFileManager defaultManager];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *fileNameSet = [manger subpathsAtPath:docDir];
        historyRecord = [NSMutableArray arrayWithArray:fileNameSet];
        [self getExtendNamedataSet:historyRecord];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
//        UIButton *returnButton = [[UIButton alloc]initWithFrame:CGRectMake(kFloatZero, kFloatZero, NAVIGATION_BTN_WIDTH, NAVIGATION_BTN_HEIGHT)];
//        
//        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem;        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
- (NSArray*)sequence:(NSArray*)timestampEnumerator
{
    NSMutableArray *keyArray = [[NSMutableArray alloc]init];
    int keyCount = [timestampEnumerator count];
    
    int *keySet = malloc(keyCount*sizeof(int));
    for (int i = 0; i != keyCount; i++)
    {
        keySet[i] = [[timestampEnumerator objectAtIndex:i] integerValue];
    }
    for (int i = 0; i != keyCount; i++)
    {
        for (int j = i+1; j != keyCount;j++)
        {
            if(keySet[i] > keySet[j])
            {
                int temp = keySet[i];
                keySet[i] = keySet[j];
                keySet[j] = temp;
            }
        }
    }
    for (int i = 0; i !=keyCount; i++)
    {
        [keyArray addObject:[NSString stringWithFormat:@"%d",keySet[i]]];
    }
    free(keySet);
    return keyArray;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *fileName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString *filNameWithNoExt = [NSString stringWithString:fileName];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileName = [fileName stringByAppendingString:@".data"];
    doc = [doc stringByAppendingPathComponent:fileName];
    NSDictionary *recordDict = [NSDictionary dictionaryWithContentsOfFile:doc];
    NSEnumerator *enumerator = [recordDict keyEnumerator];
    NSMutableArray *keySet = [[NSMutableArray alloc]init];
    for (NSString *key in enumerator)
    {
        [keySet addObject:key];
    }
    NSArray *sequenceKey = [self sequence:keySet];
    NSMutableArray *record = [[NSMutableArray alloc]init];
    
    for (NSNumber *key in sequenceKey)
    {
        [record addObject:[recordDict objectForKey:key]];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:record,@"str",filNameWithNoExt,@"fileName", nil];
    
    [obj performSelector:popViewAction withObject:dic];
    [self.navigationController popViewControllerAnimated:YES];
     
}

@end
