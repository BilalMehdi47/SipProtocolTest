//
//  File.swift
//  SipTest
//
//  Created by Bilal Mehdi on 02/09/2024.
//


import linphonesw
import Foundation

class IncomingCall: ObservableObject {
    
    static let shared = IncomingCall()
    
    var mCore: Core!
    @Published var coreVersion: String = Core.getVersion
    var mAccount: Account?
    var mCoreDelegate: CoreDelegate!
    
    
    // hard code values
    @Published var username: String = ""
    @Published var passwd: String = ""
    @Published var domain: String = "" // Linphone's free SIP service domain
    
    
    @Published var remoteAddress: String = "" // Set recipient sip account here

    
    @Published var loggedIn: Bool = false
    @Published var transportType: String = "TLS"
    
    // Incoming call related variables
    @Published var callMsg: String = ""
    @Published var isCallIncoming: Bool = false
    @Published var isCallRunning: Bool = false

    @Published var isSpeakerEnabled: Bool = false
    @Published var isMicrophoneEnabled: Bool = false
    
    init() {
        LoggingService.Instance.logLevel = LogLevel.Debug
        
        try? mCore = Factory.Instance.createCore(configPath: "", factoryConfigPath: "", systemContext: nil)
        try? mCore.start()
        
        mCoreDelegate = CoreDelegateStub(onCallStateChanged: { (core: Core, call: Call, state: Call.State, message: String) in
            self.callMsg = message
            if state == .IncomingReceived {
                self.isCallIncoming = true
                self.isCallRunning = false
                self.remoteAddress = call.remoteAddress?.asStringUriOnly() ?? "Unknown"
            } else if state == .Connected {
                self.isCallIncoming = false
                self.isCallRunning = true
            } else if state == .Released {
                self.isCallIncoming = false
                self.isCallRunning = false
                self.remoteAddress = "sip:ki@sip.linphone.org"
            }
        }, onAccountRegistrationStateChanged: { (core: Core, account: Account, state: RegistrationState, message: String) in
            if state == .Ok {
                self.loggedIn = true
            } else if state == .Cleared {
                self.loggedIn = false
            }
        })
        
        mCore.addDelegate(delegate: mCoreDelegate)
    }
    
    func login() {
        do {
            var transport: TransportType
            switch transportType {
            case "TLS": transport = .Tls
            case "TCP": transport = .Tcp
            default: transport = .Udp
            }
            
            let authInfo = try Factory.Instance.createAuthInfo(username: username, userid: "", passwd: passwd, ha1: "", realm: "", domain: domain)
            let accountParams = try mCore.createAccountParams()
            let identity = try Factory.Instance.createAddress(addr: "sip:\(username)@\(domain)")
            try accountParams.setIdentityaddress(newValue: identity)
            let address = try Factory.Instance.createAddress(addr: "sip:\(domain)")
            try address.setTransport(newValue: transport)
            try accountParams.setServeraddress(newValue: address)
            accountParams.registerEnabled = true
            
            mAccount = try mCore.createAccount(params: accountParams)
            mCore.addAuthInfo(info: authInfo)
            try mCore.addAccount(account: mAccount!)
            mCore.defaultAccount = mAccount
            
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func unregister() {
        if let account = mCore.defaultAccount {
            let params = account.params?.clone()
            params?.registerEnabled = false
            account.params = params
        }
    }
    
    func delete() {
        if let account = mCore.defaultAccount {
            mCore.removeAccount(account: account)
            mCore.clearAccounts()
            mCore.clearAllAuthInfo()
        }
    }
    
    func terminateCall() {
        do {
            try mCore.currentCall?.terminate()
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func acceptCall() {
        do {
            try mCore.currentCall?.accept()
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func muteMicrophone() {
        mCore.micEnabled.toggle()
        isMicrophoneEnabled.toggle()
    }
    
    func toggleSpeaker() {
        let currentAudioDevice = mCore.currentCall?.outputAudioDevice
        let speakerEnabled = currentAudioDevice?.type == .Speaker
        
        for audioDevice in mCore.audioDevices {
            if speakerEnabled && audioDevice.type == .Microphone {
                mCore.currentCall?.outputAudioDevice = audioDevice
                isSpeakerEnabled = false
                return
            } else if !speakerEnabled && audioDevice.type == .Speaker {
                mCore.currentCall?.outputAudioDevice = audioDevice
                isSpeakerEnabled = true
                return
            }
        }
    }
}



