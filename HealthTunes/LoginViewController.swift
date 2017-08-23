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
    var searcher: SPTSearch?
    var loginUrl: URL?
    var myPlaylist : [SPTPartialTrack] = []
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func loginBtnPressed(_ sender: Any) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
        playBtn.isHidden = false
    }
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBAction func playpauseMusic(_ sender: Any) {
        if (self.player?.playbackState.isPlaying)! {
            self.player?.setIsPlaying(false, callback: nil)
        }else{
            self.player?.setIsPlaying(true, callback: nil)
        }
        
    }
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBAction func submitPressed(_ sender: Any) {
        let data = searchField.text!
        print(data)
        searchForSongs(query: data)
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
        playBtn.isHidden = true
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
//        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
//            if (error != nil) {
//                print("playing!")
//            }
//            
//        })
        loginBtn.isHidden = true
        //searchForSongs(query: "rock")
        

        
        
    }
    func decideSearch(bpm: Double)
    {
        if(bpm < 80)
        {
            searchForSongs(query: "relaxing")
        }
        else if(bpm < 100)
        {
            searchForSongs(query: "training")
        }
        else
        {
            searchForSongs(query: "running")
        }
    }
    func searchForSongs(query: String)
    {
        
        SPTSearch.perform(withQuery: query, queryType: SPTSearchQueryType.queryTypeTrack, accessToken: self.session.accessToken, callback: { (result)
            in
            if (result != nil) {
                let listOfItems = (result.1! as! SPTListPage).items
                
                print(listOfItems!.count)
                for song in listOfItems!
                {
                    self.myPlaylist.append((song as! SPTPartialTrack))
                }
                let firstTrack = (listOfItems?[0] as! SPTPartialTrack).playableUri
                print(String(describing: firstTrack!))
                let myTrack = String(describing: firstTrack!)
                self.playSongFromURI(uri: myTrack)
                print(self.myPlaylist)
            }
        })
        
    }
    
    func playSongFromURI(uri: String)
    {
        self.player?.playSpotifyURI(uri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
            else {
                print(error)
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
