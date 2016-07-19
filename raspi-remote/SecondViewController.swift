//
//  SecondViewController.swift
//  raspi-remote
//
//  Created by behnam hajian on 2016-07-13.
//  Copyright © 2016 behnam hajian. All rights reserved.
//

import UIKit
import Starscream

class SecondViewController: UIViewController {

    
    @IBOutlet weak var cpuTempLabel: UILabel!
    
    
    let socket = WebSocket(url: NSURL(string: "ws://behnam.mybluemix.net/")!)
    var baseServiceUrl = "http://behnam.mybluemix.net/"
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //websocketDidConnect
        socket.onConnect = {
            print("websocket is connected")
        }
        //websocketDidDisconnect
        socket.onDisconnect = { (error: NSError?) in
            print("websocket is disconnected: \(error?.localizedDescription)")
        }
        //websocketDidReceiveMessage
        socket.onText = { (text: String) in
            print("got some text: \(text)")
            self.dataReceived(text)
        }
        //websocketDidReceiveData
        socket.onData = { (data: NSData) in
            print("got some data: \(data.length)")
        }
        //you could do onPong as well.
        socket.connect()
        
    }
    
    private func dataReceived(data: String){
        if(data.hasPrefix("/system/cpu_temp/")){
            let suffixIndex = data.endIndex.advancedBy(-4)
            let suffix = data.substringFromIndex(suffixIndex) // ground
            print(suffix)
            print(suffixIndex)
            self.cpuTempLabel.text = suffix
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    
    
    
    @IBAction func getCPUTempTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "system/cpu_temp")!)
        makeGetRequest(request);
    }
    
    
    @IBAction func captureTouchInside(sender: AnyObject) {
        let request = NSURLRequest(URL: NSURL(string: baseServiceUrl + "camera/capture")!)
        makeGetRequest(request);
    }


}

