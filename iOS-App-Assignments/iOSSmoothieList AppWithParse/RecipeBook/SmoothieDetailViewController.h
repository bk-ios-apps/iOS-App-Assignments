//
//  SmoothieDetailViewController.h
//  SmoothiesList
//
 

#import <UIKit/UIKit.h>
#import "Smoothie.h"

@interface SmoothieDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *smoothiePhoto;
@property (weak, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *estCostLabel;
@property (weak, nonatomic) IBOutlet UITextView *ingredientTextView;

@property (nonatomic, strong) Smoothie *smoothie;

@end
