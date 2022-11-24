//
//  ScannerViewController.swift
//  AssetTelematics_InterviewTask
//
//  Created by Macbook pro on 24/11/22.
//

import UIKit
import AVFoundation


// protocol used for sending data back
protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: String)
}

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var lblOutput: UILabel!
    var lblOutputStr: String?
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: DataEnteredDelegate? = nil
    
    var imageOrientation: AVCaptureVideoOrientation?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        self.imageOrientation = AVCaptureVideoOrientation.portrait
                              
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
                   
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            captureSession?.addOutput(capturePhotoOutput!)
            captureSession?.sessionPreset = .high
                   
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                   
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: self.previewView.layer.bounds.width, height: self.previewView.layer.bounds.height)
            previewView.layer.cornerRadius = 50
            previewView.clipsToBounds = true
            previewView.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
                   
        } catch {
            print(error)
            return
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.captureSession?.startRunning()
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let outputString = metadataObj.stringValue {
                DispatchQueue.main.async {
                    print(outputString)
                    self.lblOutputStr = outputString
                    self.lblOutput.text = outputString
                    
                    self.captureSession?.stopRunning()
                    // call this method on whichever class implements our delegate protocol
                    self.delegate?.userDidEnterInformation(info: self.lblOutputStr ?? "")
                    
                    // go back to the previous view controller
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.lblOutputStr = lblOutputStr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
