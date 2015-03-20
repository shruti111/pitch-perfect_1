//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Shruti Pawar on 06/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var player : AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        player.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func playSlowSound(sender: UIButton) {
        playSoundAtDifferentrate(audioPlayerRate: 0.5)
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        playSoundAtDifferentrate(audioPlayerRate: 2.0)
    }

    
    @IBAction func stopAudio(sender: UIButton) {
       stopAudio()
    }
    
    @IBAction func playRecordInChipmunkVoice(sender: UIButton) {
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000
        playSoundEffects(soundEffectAudioUnit: changePitchEffect)
    }
    
    @IBAction func playRecordInDarthVaderVoice(sender: UIButton) {
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        playSoundEffects(soundEffectAudioUnit: changePitchEffect)
    }
    
    @IBAction func playRecordWithReverbEffect(sender: UIButton) {
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 100
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
        playSoundEffects(soundEffectAudioUnit: reverbEffect)
        
    }
    @IBAction func playRecordWithEchoEffect(sender: UIButton) {
        let distortion = AVAudioUnitDistortion()
        distortion.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho2)
        distortion.preGain = 6
        playSoundEffects(soundEffectAudioUnit: distortion)
    }
    
    func stopAudio() {
        player.stop()
        audioEngine.stop()
    }
    func playSoundAtDifferentrate(audioPlayerRate rate:Float) {
        stopAudio()
        player.rate = rate
        player.currentTime = 0.0
        player.play()
    }
    func playSoundEffects(soundEffectAudioUnit avAudioUnit: AVAudioUnit) {
        stopAudio()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(avAudioUnit)
        
        audioEngine.connect(audioPlayerNode, to: avAudioUnit, format: nil)
        audioEngine.connect(avAudioUnit, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
}
