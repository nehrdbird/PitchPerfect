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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSlowButton(sender: UIButton) {
        //Play audio slowly
        audioPlayer.stop();
        audioPlayer.rate = 0.5;
        audioPlayer.currentTime = 0.0;
        audioPlayer.play()
        
    }
    
    @IBAction func playFastButton(sender: UIButton) {
        audioPlayer.stop();
        audioPlayer.rate = 2.0;
        audioPlayer.currentTime = 0.0;
        audioPlayer.play()
    }
    
    
    @IBAction func playChipmunkButton(sender: UIButton) {
        playSoundVariablePitch(1800)
    }
    
    @IBAction func playDarthVaderButton(sender: UIButton) {
        playSoundVariablePitch (-1800)
    }
    
    
    func playSoundVariablePitch(pitch: Float){
        audioPlayer.stop()
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
    
    
        @IBAction func stopPlaying(sender: UIButton) {
        audioPlayer.stop();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
