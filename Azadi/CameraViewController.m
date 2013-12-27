//
//  ThirdViewController.m
//  Azadi
//
//  Created by Jason Ravel on 12/23/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "CameraViewController.h"
#import <ImageIO/CGImageProperties.h>
#import <Parse/Parse.h>


@interface CameraViewController ()

@end

@implementation CameraViewController
@synthesize stillImageOutput, imageDataforAlert;

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
}

- (void) viewDidAppear:(BOOL)animated
{
    //Show camera view every time
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self embedCamera:device];

}

- (void) embedCamera: (AVCaptureDevice *) device
{
    //Displays camera screen
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    captureVideoPreviewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:captureVideoPreviewLayer];
    

    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    [session addInput:input];
    
    
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePicture:(UIButton *)sender
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         } else {
             NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         
         imageDataforAlert = imageData;
        
         //Show alert
         UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Submission Form" message:@"Enter a Caption!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upload", nil];
         alert.alertViewStyle = UIAlertViewStylePlainTextInput;
         [alert show];
         
         
         //after saving the pic to parse, show it in the mini view.
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         
         self.snappedPictureView.image = image;
         
         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
     }];
}

//If upload selected
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    
    NSString *caption = [[alertView textFieldAtIndex:0] text];
    //If upload selected
    if(buttonIndex == 1)
    {
        
        //Save the picture to Parse
        [self savepicturetoParse:imageDataforAlert part2:caption];
        
        
    }
}

- (void) savepicturetoParse:(NSData *) imageData  part2: (NSString *) caption
{
   
    //need to throw up action sheet that asks for tag and caption
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    PFUser *currentUser = [PFUser currentUser];
    PFObject *userPhoto = [PFObject objectWithClassName:@"Main_Photos"];
    userPhoto[@"snapped_pics"] = imageFile;
    userPhoto[@"User"] = currentUser;
    userPhoto[@"Caption"] = caption;
    [userPhoto saveInBackground];
}



- (IBAction)flipCamera:(UIButton *)sender
{
    //Front camera
    NSString *uniqueID =@"com.apple.avfoundation.avcapturedevice.built-in_video:1";
     AVCaptureDevice *device = [AVCaptureDevice deviceWithUniqueID:uniqueID];
    
    //if front camera, do nothing
    if([device.uniqueID isEqualToString:uniqueID])
    {
       
    }
    else //if back camera, switch to front camera
    {
        [self embedCamera:device];
    }
    

    
}
@end
