//
//  LoginViewController.swift
//  HealthTunes
//
//  Created by Anthony Picone on 8/19/17.
//  Copyright © 2017 Anthony Picone. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func loginBtnPressed(_ sender: Any) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
    func setup()
    {
        SPTAuth.defaultInstance().clientID = "1cd28b8d23924de3ae88658b97cca968"
        SPTAuth.defaultInstance().redirectURL = URL(string:"HealthTunesHome://")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope,
            SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object:nil)
        
    }
    func updateAfterFirstLogin () {
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
        func initializePlayer(authSession:SPTSession){
            if self.player == nil {
                self.player = SPTAudioStreamingController.sharedInstance()
                self.player!.playbackDelegate = self
                self.player!.delegate = self
                try! player!.start(withClientId: auth.clientID)
                self.player!.login(withAccessToken: authSession.accessToken)
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
