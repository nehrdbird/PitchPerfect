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

    @IBOutlet weak var bStopAudio: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bStopAudio.hidden = true;

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
        stopAudioPlay()
        bStopAudio.hidden = true;

    }
    
    func playSoundVariableRate(rate: Float){
        stopAudioPlay()
        audioPlayer.rate = rate;
        bStopAudio.hidden = false;
        audioPlayer.play()
    }
    
    func playSoundVariablePitch(pitch: Float){
        stopAudioPlay()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        bStopAudio.hidden = false;
        audioPlayerNode.play()

    }
    
    func stopAudioPlay(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0;
        audioEngine.stop()
        audioEngine.reset()
    }

}
