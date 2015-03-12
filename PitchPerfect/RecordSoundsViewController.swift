//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Moath_Othman on 3/10/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {


    var audioRecorder:AVAudioRecorder!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var recordedAudio :RecordedAudio!

    @IBOutlet weak var pauseResumeRecording: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingLabel.text = "Tap to Record"
        pauseResumeRecording.hidden = true
        pauseResumeRecording.setTitle("Pause", forState: .Normal)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {



        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)

        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()


        pauseResumeRecording.hidden = false
        println("in recording Audio")
        recordingLabel.text = "Recording in Progress"
         stopButton.hidden = false
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.text = "Tap to Record"
        self.audioRecorder.stop()
        AVAudioSession.sharedInstance().setActive(false, error: nil)
    }
    @IBAction func pauseOrResumeRecording(sender: UIButton) {
        if audioRecorder.recording{
            audioRecorder.pause()
            sender.setTitle("Resume", forState: .Normal)
        }else{
            if (audioRecorder != nil)  {
                audioRecorder.record()
                sender.setTitle("Pause", forState: .Normal)

            }
        }
    }


    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag{
        self.recordedAudio = RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!)

        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         if segue.identifier == "stopRecording"{
            let playSoundsVC:SoundsPlayerViewController = segue.destinationViewController as SoundsPlayerViewController
            let data = sender as RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
}

