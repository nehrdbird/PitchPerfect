//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Neha Monga on 4/26/15.
//  Copyright (c) 2015 nemon. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var receivedAudio: RecordedAudio!
    var audioFile:AVAudioFile!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true;
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func playSlowButton(sender: UIButton) {
        playSoundVariableRate(0.5)
    }
    
    @IBAction func playFastButton(sender: UIButton) {
        playSoundVariableRate(2.0)
    }
    
    
    @IBAction func playChipmunkButton(sender: UIButton) {
        playSoundVariablePitch(1800)
    }
    
    @IBAction func playDarthVaderButton(sender: UIButton) {
        playSoundVariablePitch (-1800)
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioPlayer.stop();
    }
    
    func playSoundVariableRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0;
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = rate;
        audioPlayer.play()
    }
    
    func playSoundVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0;
        audioEngine.stop()
        audioEngine.reset()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()

    }

}
