//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by shruti choksi on 20/10/17.
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
    
    override func viewWillAppear(_ animated: Bool) {
        updateUIControls(false)
    }
    
    
    @IBAction func recordAudio(_ sender: UIButton) {
        updateUIControls(true)
        
        // Create a list of document directories in UserDomain and selects the first directory path
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        // Create the current date by specifying the date formatter
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        // Create the file name using current date and time
        let recordingname = formatter.string(from: currentDate) + ".wav"
        let pathArray = [dirPath,recordingname]
        
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        // Initializes audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        // Initializes audio recorder using filepath created earlier and start recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecord(_ sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    @IBAction func pauseAudioRecording(_ sender: UIButton) {
        audioRecorder.pause()
        updateUIControls(false)
    }
    
    @IBAction func restartRecordAudio(_ sender: UIButton) {
        audioRecorder.record()
        updateUIControls(true)
    }
    
    func updateUIControls(_ isRecording : Bool) {
        
        if isRecording {
            // Recording starts for the first time and Rseume recording from pause
            recordingStatusLabel.text = "Recording in Progress"
            stopRecordingButton.isHidden = false
            recordingButton.isEnabled = false
            pauseRecordingButton.isHidden = false
            resumeRecordingButton.isHidden = false
            pauseRecordingButton.isEnabled = true
            resumeRecordingButton.isEnabled = false
        } else {
            if let _ = audioRecorder {
                //Recording is pause
                recordingStatusLabel.text = "Recording Paused"
                pauseRecordingButton.isEnabled = false
                resumeRecordingButton.isEnabled =  true
                
            } else {
                // First time when Recording screen is displayed to user
                recordingStatusLabel.text = "Tap to Record"
                recordingButton.isEnabled = true
                stopRecordingButton.isHidden = true
                pauseRecordingButton.isHidden = true
                resumeRecordingButton.isHidden = true
            }
        }
    }
    // MARK: - AVAudioRecorderDelegate Method
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio.filePathUrl)
            
        } else {
            print("Recording was not successful")
            updateUIControls(false)
        }
        audioRecorder = nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

