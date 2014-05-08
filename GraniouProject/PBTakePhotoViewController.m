#import "PBTakePhotoViewController.h"


@interface PBTakePhotoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) UIImage *capturedImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)didCancel:(id)sender;
- (IBAction)didSave:(id)sender;


@end



@implementation PBTakePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.capturedImage = [[UIImage alloc] init];

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        [toolbarItems removeObjectAtIndex:2];
        [self.toolBar setItems:toolbarItems animated:NO];
    }
    
    [_saveButton setEnabled:false];
}


- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // The user wants to use the camera interface.
        imagePickerController.showsCameraControls = YES;
    }

    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


#pragma mark - Toolbar actions

- (void)finishAndUpdate
{
    // On enleve le viewController prise de photo
    [self dismissViewControllerAnimated:YES completion:NULL];

    // Affichage de l'image prise dans imageView
    [self.imageView setImage: self.capturedImage];
    
    self.imagePickerController = nil;
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    self.capturedImage = image;
    [_saveButton setEnabled:true];

    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)didCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)didSave:(id)sender
{
    if (self.capturedImage)
    {
        
        [_delegate userDidChooseImage:self.capturedImage];
        [self.navigationController popViewControllerAnimated:true];
    }
}
@end

