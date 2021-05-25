//
//  ViewController.swift
//  isRemote
//
//  Created by Maxime on 24/05/2021.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        session.addInput(deviceInput)
        session.startRunning()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.frame = cameraView.frame
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video"))
        session.addOutput(output)
        
    }

    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: FoundRemote().model) else { return }
        let request = VNCoreMLRequest(model: model) { (req, err) in
            guard let results = req.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            
            let object = firstObservation.identifier.components(separatedBy: " ")[1]
            
            DispatchQueue.main.async {
                if firstObservation.confidence >= 0.996 {
                    self.result.text = "It's a remote"
                } else {
                    self.result.text = "Not a remote.."
                }
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

}

