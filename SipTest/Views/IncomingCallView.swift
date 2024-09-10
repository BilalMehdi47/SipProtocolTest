//
//  IncomingCallView.swift
//  SipTest
//
//  Created by Bilal Mehdi on 04/09/2024.
//

//
//import SwiftUI
//import linphonesw
//
//
//struct IncomingCallView: View {
//    @ObservedObject var incomingCallContext = IncomingCall()
//
//    var body: some View {
//        VStack {
//            Spacer()
//
//            // Display remote address (Incoming call from)
//            Text(incomingCallContext.remoteAddress)
//                .font(.title)
//                .padding()
//
//            Text(incomingCallContext.isCallRunning ? "In Call" : (incomingCallContext.isCallIncoming ? "Incoming Call" : "Idle"))
//                .font(.subheadline)
//                .foregroundColor(.gray)
//
//            Spacer()
//
//            // Incoming Call Controls
//            if incomingCallContext.isCallIncoming {
//                HStack {
//                    Button(action: {
//                        incomingCallContext.terminateCall()
//                    }) {
//                        VStack {
//                            Image(systemName: "phone.down.fill")
//                                .font(.system(size: 40))
//                                .foregroundColor(.white)
//                        }
//                        .frame(width: 70, height: 70)
//                        .background(Color.red)
//                        .clipShape(Circle())
//                        .padding()
//                    }
//
//                    Button(action: {
//                        incomingCallContext.acceptCall()
//                    }) {
//                        VStack {
//                            Image(systemName: "phone.fill")
//                                .font(.system(size: 40))
//                                .foregroundColor(.white)
//                        }
//                        .frame(width: 70, height: 70)
//                        .background(Color.green)
//                        .clipShape(Circle())
//                        .padding()
//                    }
//                }
//            } else if incomingCallContext.isCallRunning {
//                // Active Call Controls
//                HStack(spacing: 40) {
//                    Button(action: {
//                        incomingCallContext.muteMicrophone()
//                    }) {
//                        Image(systemName: incomingCallContext.isMicrophoneEnabled ? "mic.fill" : "mic.slash.fill")
//                            .font(.system(size: 40))
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    .background(Color.gray)
//                    .clipShape(Circle())
//
//                    Button(action: {
//                        incomingCallContext.terminateCall()
//                    }) {
//                        Image(systemName: "phone.down.fill")
//                            .font(.system(size: 40))
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    .background(Color.red)
//                    .clipShape(Circle())
//
//                    Button(action: {
//                        incomingCallContext.toggleSpeaker()
//                    }) {
//                        Image(systemName: incomingCallContext.isSpeakerEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
//                            .font(.system(size: 40))
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    .background(Color.gray)
//                    .clipShape(Circle())
//                }
//                .padding(.bottom, 50)
//            }
//
//            Spacer()
//        }
//        .background(Color.black.opacity(0.85).edgesIgnoringSafeArea(.all))
//    }
//}
