//
//  SmoothieDetailViewController.m
//  SmoothiesList
//
 
#import "SmoothieDetailViewController.h"

@interface SmoothieDetailViewController ()

@end

@implementation SmoothieDetailViewController

@synthesize smoothiePhoto;
@synthesize prepTimeLabel;
@synthesize estCostLabel;
@synthesize ingredientTextView;
@synthesize smoothie;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = smoothie.name;
    self.prepTimeLabel.text = smoothie.prepTime;
    self.estCostLabel.text = smoothie.estimatedCost;
    self.smoothiePhoto.file = smoothie.imageFile;
    
    NSMutableString *ingredientText = [NSMutableString string];
    for (NSString* ingredient in smoothie.ingredients) {
        [ingredientText appendFormat:@"%@\n", ingredient];
    }
    self.ingredientTextView.text = ingredientText;
    
}

- (void)viewDidUnload
{
    [self setSmoothiePhoto:nil];
    [self setPrepTimeLabel:nil];
    [self setEstCostLabel:nil];
    [self setIngredientTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
