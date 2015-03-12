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
    var audioEngine = AVAudioEngine()!
    var audioFile:AVAudioFile!

    @IBOutlet weak var slowButton: UIButton!

    override func viewDidLoad() {


        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)

        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL:  recievedAudio.filePathUrl, error: &error)
        audioPlayer.enableRate = true
        audioPlayer.volume  = 1.0
        var overrideError : NSError?
        if AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker, error: &error){

        }else{
            print("error in overrideOutputAudioPort " + overrideError!.localizedDescription)
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
        var changePitchEffect = AVAudioUnitTimePitch()
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
         var changePitchEffect = AVAudioUnitTimePitch()
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

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(Effect )

        audioEngine.connect(audioPlayerNode, to: Effect, format: nil)
        audioEngine.connect(Effect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    @IBAction func playDistortionEffect(sender: AnyObject) {

        var distortionEffect = AVAudioUnitDistortion()

        distortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho2)

        playAudioWithVEffect(distortionEffect)
    }


}
