//
//  FirstViewController.swift
//  raspi-remote
//
//  Created by behnam hajian on 2016-07-13.
//  Copyright © 2016 behnam hajian. All rights reserved.
//

import UIKit
import TextToSpeechV1
import AVFoundation
import SpeechToTextV1
import Foundation

class FirstViewController: UIViewController {

    var player: AVAudioPlayer?
    var captureSession: AVCaptureSession?
    var recorder: AVAudioRecorder!
    @IBOutlet weak var transcribedLabel: UILabel!
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var baseServiceUrl = "http://behnam.mybluemix.net/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let document = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let fileName = "speechToTextRecording.wav"
        let filePath = NSURL(fileURLWithPath: document + "/" + fileName)
        let session = AVAudioSession.sharedInstance()
        var settings = [String: AnyObject] ()
        settings[AVSampleRateKey] = NSNumber(float: 44100.0)
        settings[AVNumberOfChannelsKey] = NSNumber(int: 1)
        do{
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            recorder = try AVAudioRecorder(URL: filePath, settings: settings)
        } catch{
            
        }
        
        guard let recorder = recorder else {
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func listenTouchDown(sender: UIButton) {
        if (!recorder.recording) {
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setActive(true)
                recorder.record()
                sender.alpha = 1
            } catch {
                
            }
        } else {
            do {
                recorder.stop()
                sender.alpha = 0.5
                let session = AVAudioSession.sharedInstance()
                try session.setActive(false)
                let username = "87bb86cb-61a5-4742-afec-26a7f23c592e"
                let password = "FxxzwmJ5Dgrj"
                let speechToText = SpeechToText(username: username, password: password)
                let settings = TranscriptionSettings(contentType: .WAV)
                let failure = { (error: NSError) in print(error) }
                speechToText.transcribe(recorder.url, settings: settings, failure: failure){
                    result in if let transcription = result.last?.alternatives.last?.transcript{
                        self.transcribedLabel.text = transcription
                        
                        let command = transcription.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
                        
                        if(command == "forward"){
                            self.forwardTouchInside(sender)
                        }
                        if(command == "backward"){
                            self.backwardTouchInside(sender)
                        }
                        if(command == "turn left"){
                            self.leftTouchInside(sender)
                        }
                        if(command == "turn right"){
                            self.rightTouchInside(sender)
                        }
                        if(command == "stop"){
                            self.stopTouchInside(sender)
                        }
                    }
                }
            } catch {}
        }
    }
    
    private func makeGetRequest(request: NSURLRequest){
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                let response = NSString(data: data, encoding: NSUTF8StringEncoding)
                print(response)
            }
        }
        task.resume()
    }
    
    
    @IBAction func forwardTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "car/goForward")!)
        makeGetRequest(request);
    }
    

    @IBAction func backwardTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "car/goBackward")!)
        makeGetRequest(request);
    }
    @IBAction func rightTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "car/turnRight/coarse")!)
        makeGetRequest(request);
    }
    
    @IBAction func leftTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "car/turnLeft/coarse")!)
        makeGetRequest(request);
    }
    
    @IBAction func stopTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "car/stop")!)
        makeGetRequest(request);
    }
    
    @IBAction func speedValueChanged(sender: UISlider) {
        let selectedValue = Int(sender.value)
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "car/setSpeed/" + String(selectedValue))!)
        makeGetRequest(request);
    }
    
    @IBAction func cameraUpTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "camera/up")!)
        makeGetRequest(request);
    }
    
    @IBAction func cameraDownTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "camera/down")!)
        makeGetRequest(request);
    }
    
    @IBAction func cameraRightTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "camera/right")!)
        makeGetRequest(request);
    }
    
    @IBAction func cameraLeftTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "camera/left")!)
        makeGetRequest(request);
    }
    
    @IBAction func cameraHomeTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "camera/home")!)
        makeGetRequest(request);
    }
    
    
    
    
    

}

