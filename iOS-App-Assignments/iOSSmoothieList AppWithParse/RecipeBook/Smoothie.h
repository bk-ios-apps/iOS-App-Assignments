//
//  Smoothie.h
//  SmoothiesList
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Smoothie : NSObject

@property (nonatomic, strong) NSString *name; // name of recipe
@property (nonatomic, strong) NSString *prepTime; // preparation time
@property (nonatomic, strong) PFFile *imageFile; // image of recipe
@property (nonatomic, strong) NSArray *ingredients; // ingredients
@property (nonatomic, strong) NSString *estimatedCost; // cost of ingredients

@end
