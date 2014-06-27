//
//  SmoothieListViewController.m
//  SmoothiesList
//
 

#import "SmoothieListViewController.h"
#import "SmoothieDetailViewController.h"
#import "Smoothie.h"

@interface SmoothieListViewController ()

@end

@implementation SmoothieListViewController {
    
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Smoothie";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];
}

- (void)refreshTable:(NSNotification *) notification
{
    // Reload the smoothies
    [self loadObjects];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
/*    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }*/
    
//    [query orderByAscending:@"name"];
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"SmoothieCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    //PFFile *thumbnail = [object objectForKey:@"imageFile"];
    //PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    //thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    //thumbnailImageView.file = thumbnail;
    //[thumbnailImageView loadInBackground];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"name"];
    
    UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
    prepTimeLabel.text = [object objectForKey:@"prepTime"];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSmoothieDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SmoothieDetailViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        Smoothie *smoothie = [[Smoothie alloc] init];
        smoothie.name = [object objectForKey:@"name"];
        smoothie.imageFile = [object objectForKey:@"imageFile"];
        smoothie.prepTime = [object objectForKey:@"prepTime"];
        smoothie.ingredients = [object objectForKey:@"ingredients"];
        smoothie.estimatedCost = [object objectForKey:@"estimatedCost"];
        destViewController.smoothie = smoothie;
        
    }
}


@end
