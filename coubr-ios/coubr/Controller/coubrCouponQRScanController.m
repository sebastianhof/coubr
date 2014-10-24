//
//  coubrCouponQRScanController.m
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrCouponQRScanController.h"

@interface coubrCouponQRScanController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *videoPreview;

@end

@implementation coubrCouponQRScanController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initVideoPreview];
    [self.captureSession startRunning];
}

#pragma mark - init

- (void)initVideoPreview
{
    if (!self.videoPreviewLayer) {
        self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.videoPreviewLayer setFrame:self.videoPreview.layer.bounds];
        [self.videoPreview.layer addSublayer:self.videoPreviewLayer];
    }
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        
        NSError *error;
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // init input
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (error) {
            NSLog(@"Could not get media device %@", [error localizedDescription]);
            return nil;
        }

        // init output
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        dispatch_queue_t dispatch_queue = dispatch_queue_create("QRCodeScanningQueue", NULL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_queue];
        
        // init capture session
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        [_captureSession addOutput:captureMetadataOutput];
 
        if ([[captureMetadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
            
            [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
        }
 
    }
    return _captureSession;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.captureSession stopRunning];
    
        if (metadataObjects && metadataObjects.count > 0) {
            
            AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
            if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
             
                NSString *qrCode = metadataObject.stringValue;
                
                if ([qrCode length] < 139) {
                    
                    [self.parentController didFailToRedeem];
                    
                } else {
                    
                    if ([[qrCode substringToIndex:10] isEqualToString:@"coubrStore:"]) {
                     
                       [self.parentController didFailToRedeem];
                        
                    } else {

                        NSString *code = [qrCode substringFromIndex:11];
                        [self.parentController willRedeemWithCode:code];
                        
                    }
                    
                }

            }
            
            

            
        }
        
        // clean up
        self.videoPreviewLayer = nil;
        self.captureSession = nil;
        
    }];
    
}

#pragma mark - dismiss

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
       
        [self.captureSession stopRunning];
        
        // clean up
        self.videoPreviewLayer = nil;
        self.captureSession = nil;
        
    }];
    
}


@end
