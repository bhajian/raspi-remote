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

class FirstViewController: UIViewController {

    var player: AVAudioPlayer?
    var captureSession: AVCaptureSession?
    var recorder: AVAudioRecorder!
    @IBOutlet weak var transcribedLabel: UILabel!
    
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
                    result in if let Transcription = result.last?.alternatives.last?.transcript{
                        self.transcribedLabel.text = Transcription
                    }
                }
            } catch {}
        }
    }

}

