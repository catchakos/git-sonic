//
//  PDInstance.swift
//  git-sonic
//
//  Created by Alexis Katsaprakakis on 07/07/16.
//  Copyright © 2016 phonegroove. All rights reserved.
//

import UIKit

class PDInstance: NSObject, PdReceiverDelegate {

    var audioController = PdAudioController()
    
    func launchPD() {
        audioController.configurePlaybackWithSampleRate(44100, numberChannels: 2, inputEnabled: false, mixingEnabled: true)
        PdBase.openFile("test.pd", path: NSBundle.mainBundle().resourcePath)
        audioController.active = true
        audioController.print()
        
        PdBase.sendBangToReceiver("bang")
        PdBase.setDelegate(self)
    }
    
    func receivePrint(message: String!) {
        print("PD says : \(message)")
    }
    
    func changeFreq(hz: Float){
        PdBase.sendFloat(hz, toReceiver: "frequency")
    }
    
}
