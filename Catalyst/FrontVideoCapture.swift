//
//  FrontVideoCapture.swift
//  Catalyst
//
//  Created by Utku Tarhan on 3/31/20.
//  Copyright © 2020 Utku Tarhan. All rights reserved.
//
//  The code was written for personal/educational purposes on San Francisco State University
//  Does not infringe any conflict of interest with Apple Business Conduct 2020.
//
// Version 1.0.3

import UIKit
import AVFoundation
import CoreVideo

public protocol FrontVideoCaptureDelegate: class {
  func frontVideoCapture(_ capture: FrontVideoCapture, didCaptureVideoFrame: CVPixelBuffer?, timestamp: CMTime)
}


public class FrontVideoCapture: NSObject {
  public var previewLayer: AVCaptureVideoPreviewLayer?
  public weak var delegate: FrontVideoCaptureDelegate?
  public var desiredFrameRate = 30
    
  let captureSession = AVCaptureSession()
  let frontVideoOutput = AVCaptureVideoDataOutput()
  let queue = DispatchQueue(label: "com.utkutarhan.camera-queue")

  public func setUp(sessionPreset: AVCaptureSession.Preset = .medium,
                    completion: @escaping (Bool) -> Void) {
    queue.async {
      let success = self.setUpCamera(sessionPreset: sessionPreset)
      DispatchQueue.main.async {
        completion(success)
      }
    }
  }

    
  func setUpCamera(sessionPreset: AVCaptureSession.Preset) -> Bool {
    captureSession.beginConfiguration()
    captureSession.sessionPreset = sessionPreset

    guard let frontCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
    for: .video,
    position: .front)
        else {
            print("No front camera found. The device might be experiencing camera issues.")
            return false
    }
        

        
    guard let frontVideoInput = try? AVCaptureDeviceInput(device: frontCaptureDevice) else {
      print("Error: could not create AVCaptureDeviceInput")
      return false
    }

    if captureSession.canAddInput(frontVideoInput) {
      captureSession.addInput(frontVideoInput)
    }

    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
    previewLayer.connection?.videoOrientation = .portrait
    self.previewLayer = previewLayer

    let settings: [String : Any] = [
      kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
    ]

    frontVideoOutput.videoSettings = settings
    frontVideoOutput.alwaysDiscardsLateVideoFrames = true
    frontVideoOutput.setSampleBufferDelegate(self, queue: queue)
    if captureSession.canAddOutput(frontVideoOutput) {
      captureSession.addOutput(frontVideoOutput)
    }

    // We want the buffers to be in portrait orientation otherwise they are
    // rotated by 90 degrees. Need to set this _after_ addOutput()!
    frontVideoOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait

    // Based on code from https://github.com/dokun1/Lumina/
    let activeDimensions = CMVideoFormatDescriptionGetDimensions(frontCaptureDevice.activeFormat.formatDescription)
    for vFormat in frontCaptureDevice.formats {
      let dimensions = CMVideoFormatDescriptionGetDimensions(vFormat.formatDescription)
      let ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
      if let frameRate = ranges.first,
         frameRate.maxFrameRate >= Float64(desiredFrameRate) &&
         frameRate.minFrameRate <= Float64(desiredFrameRate) &&
         activeDimensions.width == dimensions.width &&
         activeDimensions.height == dimensions.height &&
         CMFormatDescriptionGetMediaSubType(vFormat.formatDescription) == 875704422 { // meant for full range 420f
        do {
          try frontCaptureDevice.lockForConfiguration()
          frontCaptureDevice.activeFormat = vFormat as AVCaptureDevice.Format
          frontCaptureDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(desiredFrameRate))
          frontCaptureDevice.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(desiredFrameRate))
          frontCaptureDevice.unlockForConfiguration()
          break
        } catch {
          continue
        }
      }
    }
    print("Camera format:", frontCaptureDevice.activeFormat)

    captureSession.commitConfiguration()
    return true
  }

  public func start() {
    if !captureSession.isRunning {
      captureSession.startRunning()
    }
  }

  public func stop() {
    if captureSession.isRunning {
      captureSession.stopRunning()
    }
    
    }
    }
  


extension FrontVideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
    let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
    delegate?.frontVideoCapture(self, didCaptureVideoFrame: imageBuffer, timestamp: timestamp)
  }

  public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    //print("dropped frame")
  }
}

