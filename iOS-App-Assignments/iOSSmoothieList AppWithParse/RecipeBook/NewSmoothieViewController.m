//
//  NewSmoothieViewController.m
//  SmoothiesList
//
 

#import "NewSmoothieViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface NewSmoothieViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *smoothieImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *ingredientsTextField;
@property (weak, nonatomic) IBOutlet UITextField *estimatedCostTextField;

@end

@implementation NewSmoothieViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _nameTextField.delegate = self;
    _prepTimeTextField.delegate = self;
    _ingredientsTextField.delegate = self;
    _estimatedCostTextField.delegate =self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showPhotoLibary];
    }
}


- (void)showPhotoLibary
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    [self.navigationController presentModalViewController: mediaUI animated: YES];
}

- (IBAction)save:(id)sender {
    // Create PFObject with recipe information
    PFObject *smoothie = [PFObject objectWithClassName:@"Smoothie"];
    [smoothie setObject:_nameTextField.text forKey:@"name"];
    [smoothie setObject:_prepTimeTextField.text forKey:@"prepTime"];
    [smoothie setObject:_estimatedCostTextField.text forKey:@"estimatedCost"];
    
    NSArray *ingredients = [_ingredientsTextField.text componentsSeparatedByString: @","];
    [smoothie setObject:ingredients forKey:@"ingredients"];
    
    // Smoothie image
    NSData *imageData = UIImageJPEGRepresentation(_smoothieImageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", _nameTextField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [smoothie setObject:imageFile forKey:@"imageFile"];
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];

    // Upload smoothie to Parse
    [smoothie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Smoothie added!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the smoothies from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller ---- disabled because of bug that causes app to crash - Bipul Karki
            //[self dismissViewControllerAnimated:YES completion:nil];
            
            //Instead added these codes to clear the text fields
            _nameTextField.text = @" ";
            _prepTimeTextField.text = @" ";
            _ingredientsTextField.text = @" ";
            _estimatedCostTextField.text = @" ";

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

        }
        
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setSmoothieImageView:nil];
    [self setNameTextField:nil];
    [self setPrepTimeTextField:nil];
    [self setIngredientsTextField:nil];
    [self setEstimatedCostTextField:nil];
    [super viewDidUnload];
}


- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {

    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.smoothieImageView.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
