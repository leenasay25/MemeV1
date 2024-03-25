//
//  RecordSoundsViewController.swift
//  recoredAudioApp
//
//  Created by Leena Alsayari on 27/08/2022.
//

import UIKit
import AVFoundation
import Foundation

class RecordSoundsViewController : UIViewController, AVAudioRecorderDelegate {
        
    var audioRecorder: AVAudioRecorder?
    @IBOutlet weak var RecoredButton: UIButton!
    @IBOutlet weak var recoredLabel: UILabel!
    @IBOutlet weak var stopRecoredButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecoredButton.isEnabled = false
        // Do any additional setup after loading the view.
    }


    
    func configureUI(_ isRecording: Bool) {
        stopRecoredButton.isEnabled = isRecording
        RecoredButton.isEnabled = !isRecording
        recoredLabel.text = isRecording ? "Recording in Progress" : "Tap To Recored"
        }
    
    @IBAction func recoredAudio(_ sender: Any) {
        configureUI( true )
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI( false )
        audioRecorder?.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{

        performSegue(withIdentifier: "stopRecording", sender: audioRecorder?.url)
    }
        else{
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

