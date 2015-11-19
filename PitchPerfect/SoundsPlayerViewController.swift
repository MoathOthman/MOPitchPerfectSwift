//
//  SoundsPlayerViewController.swift
//  PitchPerfect
//
//  Created by Moath_Othman on 3/11/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import UIKit
import AVFoundation

class SoundsPlayerViewController: UIViewController {
     var audioWithEffectPlayer: MOAudioPlayer!
    var recievedAudio : RecordedAudio!

    @IBOutlet weak var slowButton: UIButton!
    
    override func viewDidLoad() {
        audioWithEffectPlayer = MOAudioPlayer(recievedAudio: recievedAudio)
    }
    @IBAction func playAudioFast(sender: AnyObject) {
        audioWithEffectPlayer.playAudioWithRate(2)
    }
    @IBAction func stopPlaying(sender: AnyObject) {
        audioWithEffectPlayer.stopPlaying()
    }
    @IBAction func playChipmunkSound(sender: AnyObject) {
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch =  1000
        audioWithEffectPlayer.playAudioWithVEffect(changePitchEffect)
    }
    @IBAction func playSlowSound(sender: AnyObject) {
        audioWithEffectPlayer.playAudioWithRate(0.5)
    }
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        audioWithEffectPlayer.playAudioWithVEffect(changePitchEffect)
    }
    
    @IBAction func playDistortionEffect(sender: AnyObject) {
        let distortionEffect = AVAudioUnitDistortion()
        distortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho2)
        audioWithEffectPlayer.playAudioWithVEffect(distortionEffect)
    }
    
    
}

class MOAudioPlayer {
    var audioPlayer = AVAudioPlayer()
    var audioEngine = AVAudioEngine()
    var audioFile: AVAudioFile!
    
    init(recievedAudio: RecordedAudio) {
        audioFile = try? AVAudioFile(forReading: recievedAudio.filePathUrl)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL:  recievedAudio.filePathUrl)
        } catch _ as NSError {
            
        }
        audioPlayer.enableRate = true
        audioPlayer.volume  = 1.0
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker)
        } catch let err  as NSError {
            print("error in overrideOutputAudioPort " + err.localizedDescription, terminator: "")
        }
    }
    
    @IBAction func playAudioWithRate(rate: Float) {
        audioPlayer.rate = 2
        audioEngine.reset()
        audioEngine.stop()
        self.playAudio()
        
    }
    
    
    func playAudio(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    func stopPlaying() {
        audioPlayer.stop()
        audioEngine.reset()
        audioEngine.stop()
    }
    
    //New Function
    func playAudioWithVEffect(Effect: AVAudioNode){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(Effect )
        
        audioEngine.connect(audioPlayerNode, to: Effect, format: nil)
        audioEngine.connect(Effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    
}
