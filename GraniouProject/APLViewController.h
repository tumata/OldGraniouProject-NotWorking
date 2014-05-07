#import <UIKit/UIKit.h>


@protocol TakePictureDelegate;

@interface APLViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// Déclaration de la propriété delegate,
// qui est un objet devant implémenter le protocol AddTaskDelegate
@property (nonatomic, assign) id<TakePictureDelegate> delegate;

@end



// Déclaration du protocol
@protocol TakePictureDelegate <NSObject>
@required
- (void)userDidChooseImage:(UIImage *) imageChosen;
@end