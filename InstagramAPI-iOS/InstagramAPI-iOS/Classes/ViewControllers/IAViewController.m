//
//  IAViewController.m
//  InstagramAPI-iOS
//
//  Created by Sergei Pekar on 6/29/13.
//  Copyright (c) 2013 Sergei Pekar. All rights reserved.
//

#import "IAViewController.h"

@interface IAViewController ()
- (void) initSelf;
@end

@implementation IAViewController

#pragma mark - Initialization
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initSelf];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void) initSelf
{
    _imageQueue = dispatch_queue_create("com.instagramapi.imagequeue", NULL);

    self.manager = [IAServerManager getInstanse];
    self.manager.delegate = self;
    
    self.imageUrls = [NSArray new];
    self.imageCache = [NSCache new];
    [self.imageCache setName:@"com.instagramapi.imagecache"];
    [self.imageCache setCountLimit:40];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.manager performSelectorInBackground:@selector(requestForImages) withObject:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.imageUrls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    IAImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    [cell.progress startAnimating];
    
    NSString *imageUrl = [self.imageUrls objectAtIndex:[indexPath row]];
    UIImage* image = [self.imageCache objectForKey:imageUrl];
    
    if (image) {
        cell.imageView.image = image;
        [cell.progress stopAnimating];
        
    } else {
        cell.imageView.image = [UIImage imageNamed:@"plaseholder.jpeg"];
        
        dispatch_async(_imageQueue, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];                
                UITableViewCell *lookedUpCell = [tableView cellForRowAtIndexPath:indexPath];
                
                if (lookedUpCell){
                    lookedUpCell.imageView.image = image;
                            [cell.progress stopAnimating];
                    [lookedUpCell setNeedsLayout];
                }
                
                [self.imageCache setObject:image forKey:imageUrl];
            });
        });
    }
    
    cell.imageIndexTxt.text = [NSString stringWithFormat:@"%d", [indexPath row]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - IAServerMamagerDelegate

- (void)showProgress
{
    
}

- (void)dismissProgress
{
    
}

- (void)didReceiveImageUrls:(NSArray *)urls
{
    self.imageUrls = urls;
    
    if ([self.imageUrls count] == 9) {
        [[[UIAlertView alloc] initWithTitle:@"No data" message:@"No urls received" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else {
        [self.tableView reloadData];
    }
    
    NSLog(@"Urls received");
    
    for (NSString* url in urls) {
        NSLog(@"url: %@\n", url);
    }
}
@end
