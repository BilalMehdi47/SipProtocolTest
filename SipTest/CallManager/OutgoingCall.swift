//
//  OutgoingCall.swift
//  SipTest
//
//  Created by Bilal Mehdi on 04/09/2024.
//

// View Model

import Foundation
import linphonesw
import AVFoundation

class OutgoingCall: ObservableObject {
    
    static let shared = OutgoingCall()
    
    var mCore: Core!
    @Published var loggedIn: Bool = false
    @Published var isCallRunning: Bool = false
    
    
//     Hardcoded test credential
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var domain: String = "" // Linphone's free SIP service domain
    
    
    @Published var remoteAddress: String = "" // Set recipient sip account here

    
    var mRegistrationDelegate: CoreDelegate!
    
    init() {
        initialSetup()
    }
    
    func initialSetup() {
        try? mCore = Factory.Instance.createCore(configPath: "", factoryConfigPath: "", systemContext: nil)
        mCore.videoCaptureEnabled = true
        mCore.videoDisplayEnabled = true
        mCore.videoActivationPolicy?.automaticallyAccept = true
        try? mCore.start()
        
        mRegistrationDelegate = CoreDelegateStub(
            onCallStateChanged: { (core: Core, call: Call, state: Call.State, message: String) in
                self.handleCallState(state: state, message: message)
            },
            onAccountRegistrationStateChanged: { (core: Core, account: Account, state: RegistrationState, message: String) in
                if state == .Ok {
                    self.loggedIn = true
                    print("Successfully logged in!")
                    self.makeCall() // Make the call after successful login
                } else if state == .Cleared {
                    self.loggedIn = false
                    print("Failed to log in.")
                }
            }
        )
        
        mCore?.addDelegate(delegate: mRegistrationDelegate)
    }
    
    func handleCallState(state: Call.State, message: String) {
        switch state {
        case .OutgoingInit:
            print("Outgoing call is being initialized...")
        case .OutgoingProgress:
            print("Outgoing call in progress...")
        case .OutgoingRinging:
            print("Phone is ringing...")
        case .Connected:
            print("Call connected.")
        case .StreamsRunning:
            self.isCallRunning = true
            print("Call is running with media streams.")
        case .Released:
            self.isCallRunning = false
            print("Call ended.")
        case .Error:
            print("Call encountered an error: \(message)")
        default:
            break
        }
    }
    
    // Proper audio session configuration for VoIP calls
    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true)
            print("Audio session configured.")
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
    
    func login() {
        do {
            let transport: TransportType = .Tls // Use TLS for secure transport
            
            let authInfo = try Factory.Instance.createAuthInfo(username: username, userid: "", passwd: password, ha1: "", realm: "", domain: domain)
            let accountParams = try mCore.createAccountParams()
            let identity = try Factory.Instance.createAddress(addr: "sip:\(username)@\(domain)")
            try accountParams.setIdentityaddress(newValue: identity)
            let address = try Factory.Instance.createAddress(addr: "sip:\(domain)")
            try address.setTransport(newValue: transport)
            try accountParams.setServeraddress(newValue: address)
            accountParams.registerEnabled = true
            
            let account = try mCore.createAccount(params: accountParams)
            mCore.addAuthInfo(info: authInfo)
            try mCore.addAccount(account: account)
            mCore.defaultAccount = account
        } catch {
            print("Login error: \(error.localizedDescription)")
        }
    }
    
    func makeCall() {
        configureAudioSession() // Configure audio before making the call
        
        do {
            let address = try Factory.Instance.createAddress(addr: remoteAddress)
            let callParams = try mCore.createCallParams(call: nil)
            callParams.mediaEncryption = .None
            let _ = mCore.inviteAddressWithParams(addr: address, params: callParams)
        } catch {
            print("Error making call: \(error.localizedDescription)")
        }
    }
    
    func terminateCall() {
        do {
            let call = mCore.currentCall ?? mCore.calls.first
            try call?.terminate()
            print("Call terminated.")
        } catch {
            print("Error terminating call: \(error.localizedDescription)")
        }
        
        // Deactivate the audio session after the call ends
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            print("Audio session deactivated.")
        } catch {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
}

