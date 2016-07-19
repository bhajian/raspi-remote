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
    
    
    let socket = WebSocket(url: NSURL(string: "ws://localhost:3000/")!)
    
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
        }
        //websocketDidReceiveData
        socket.onData = { (data: NSData) in
            print("got some data: \(data.length)")
        }
        //you could do onPong as well.
        socket.connect()
        
    }
    
    private func dataReceived(data: String){
        if(data.hasPrefix("/system/cpu_temp")){
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func getCPUTempTouchInside(sender: AnyObject) {
    
    }
    
    
    @IBAction func captureTouchInside(sender: AnyObject) {
        
    }


}

