//
//  coubrQRScanController.m
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrQRScanController.h"
#import "coubrQRScanDelegate.h"

@interface coubrQRScanController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *videoPreview;

@end

@implementation coubrQRScanController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initVideoPreview];
    [self.captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.captureSession stopRunning];
    
    self.videoPreviewLayer = nil;
    self.captureSession = nil;
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

#define STORE_CODE_PREQUEL @"coubrStore:"

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.captureSession stopRunning];
    
    if (self.delegate) {
    
        if (metadataObjects && metadataObjects.count > 0) {
            
            AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
            if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {

                NSString *qrCode = metadataObject.stringValue;
                
                if ([[qrCode substringToIndex:11] isEqualToString:@"coubrStore:"] && qrCode.length == 139) {
                    
                    // ok
                    NSString *storeCode = [qrCode substringFromIndex:11];
                    [self.delegate didScanQRCode:storeCode];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    return;
                    
                } 
 
            }
            
        }
        
        [self.delegate didFailScanning];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    
}

#pragma mark - dismiss

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
