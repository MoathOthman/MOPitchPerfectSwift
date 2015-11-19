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
    var audioPlayer = AVAudioPlayer()
    var recievedAudio : RecordedAudio!
    var audioEngine = AVAudioEngine()
    var audioFile:AVAudioFile!

    @IBOutlet weak var slowButton: UIButton!

    override func viewDidLoad() {


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
    @IBAction func playAudioFast(sender: AnyObject) {
        audioPlayer.rate = 2
        audioEngine.reset()
        audioEngine.stop()
        self.playAudio()

    }
    @IBAction func stopPlaying(sender: AnyObject) {
        audioPlayer.stop()
    }
    @IBAction func playChipmunkSound(sender: AnyObject) {
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch =  1000
        playAudioWithVEffect(changePitchEffect)    }
    @IBAction func playSlowSound(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioEngine.reset()
        audioEngine.stop()
        self.playAudio()

    }
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
         let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        playAudioWithVEffect(changePitchEffect)

    }

    func playAudio(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
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
    @IBAction func playDistortionEffect(sender: AnyObject) {

        let distortionEffect = AVAudioUnitDistortion()

        distortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho2)

        playAudioWithVEffect(distortionEffect)
    }


}
