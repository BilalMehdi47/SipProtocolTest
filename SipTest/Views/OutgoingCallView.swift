////
////  OutgoingCallView.swift
////  SipTest
////
////  Created by Bilal Mehdi on 04/09/2024.
////
//
//
//import SwiftUI
//import linphonesw
//
//struct OutgoingCallView: View {
//    @ObservedObject var outgoingCallContext = OutgoingCall()
//
//    var body: some View {
//        VStack {
//            Spacer()
//
//            // Input for SIP address
//            TextField("SIP Address", text: $outgoingCallContext.remoteAddress)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            Text(outgoingCallContext.isCallRunning ? "Calling \(outgoingCallContext.remoteAddress)" : "Enter a number to call")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//
//            Spacer()
//
//            // Outgoing Call Controls
//            if outgoingCallContext.isCallRunning {
//                HStack(spacing: 40) {
//                    Button(action: {
//                        outgoingCallContext.toggleVideo()
//                    }) {
//                        Image(systemName: outgoingCallContext.isVideoEnabled ? "video.fill" : "video.slash.fill")
//                            .font(.system(size: 40))
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    .background(Color.gray)
//                    .clipShape(Circle())
//
//                    Button(action: {
//                        outgoingCallContext.terminateCall()
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
//                        outgoingCallContext.toggleCamera()
//                    }) {
//                        Image(systemName: "camera.fill")
//                            .font(.system(size: 40))
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    .background(Color.gray)
//                    .clipShape(Circle())
//                }
//                .padding(.bottom, 50)
//            } else {
//                Button(action: {
//                    outgoingCallContext.outgoingCall()
//                }) {
//                    VStack {
//                        Image(systemName: "phone.fill")
//                            .font(.system(size: 40))
//                            .foregroundColor(.white)
//                    }
//                    .frame(width: 70, height: 70)
//                    .background(Color.green)
//                    .clipShape(Circle())
//                    .padding()
//                }
//            }
//
//            Spacer()
//        }
//        .background(Color.black.opacity(0.85).edgesIgnoringSafeArea(.all))
//    }
//}
