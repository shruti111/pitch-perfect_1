//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Shruti Pawar on 05/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    @IBOutlet weak var resumeRecordingButton: UIButton!
    @IBOutlet weak var pauseRecordingButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
       updateUIControls(false)
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
       updateUIControls(true)
        
        // Create a list of document directories in UserDomain and selects the first directory path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Create the current date by specifying the date formatter
        let currentDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        // Create the file name using current date and time
        let recordingname = formatter.stringFromDate(currentDate) + ".wav"
        let pathArray = [dirPath,recordingname]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Initializes audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // Initializes audio recorder using filepath created earlier and start recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecord(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    @IBAction func pauseAudioRecording(sender: UIButton) {
        audioRecorder.pause()
        updateUIControls(false)
    }
    
     @IBAction func restartRecordAudio(sender: UIButton) {
        audioRecorder.record()
        updateUIControls(true)
    }
    
    func updateUIControls(isRecording : Bool) {
       
        if isRecording {
            // Recording starts for the first time and Rseume recording from pause
            recordingStatusLabel.text = "Recording in Progress"
            stopRecordingButton.hidden = false
            recordingButton.enabled = false
            pauseRecordingButton.hidden = false
            resumeRecordingButton.hidden = false
            pauseRecordingButton.enabled = true
            resumeRecordingButton.enabled = false
        } else {
            if let recorder = audioRecorder {
                //Recording is pause
                recordingStatusLabel.text = "Recording Paused"
                pauseRecordingButton.enabled = false
                resumeRecordingButton.enabled =  true

            } else {
            // First time when Recording screen is displayed to user
            recordingStatusLabel.text = "Tap to Record"
            recordingButton.enabled = true
            stopRecordingButton.hidden = true
            pauseRecordingButton.hidden = true
            resumeRecordingButton.hidden = true
            }
        }
    }
    // MARK: - AVAudioRecorderDelegate Method
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            println("Recording was not successful")
            updateUIControls(false)
        }
        audioRecorder = nil
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destinationViewController as PlaySoundsViewController
            var data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

}

