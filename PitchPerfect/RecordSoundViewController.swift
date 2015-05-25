//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Neha Monga on 4/20/15.
//  Copyright (c) 2015 nemon. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var RecordingInProgress: UILabel!
    @IBOutlet weak var bStopButton: UIButton!
    @IBOutlet weak var bRecordButton: UIButton!
    @IBOutlet weak var lTapToRecord: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Hide the stop button
        bStopButton.hidden = true;
        lTapToRecord.hidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            //Save recoded video
            recordedAudio = RecordedAudio (filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            //Move to next scene and perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Oops, something went wrong and recording was not successful")
            bStopButton.hidden = true;
            bRecordButton.enabled = true;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        // UI Treatment
        RecordingInProgress.hidden = true;
        bRecordButton.hidden = false;
        
        //Stopping recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    @IBAction func recordAudio(sender: UIButton) {
        // UI Treatment
        RecordingInProgress.hidden = false;
        bStopButton.hidden = false;
        lTapToRecord.hidden = true;
        
        //Setting path for saving the audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Starting a session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Starting recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
}

