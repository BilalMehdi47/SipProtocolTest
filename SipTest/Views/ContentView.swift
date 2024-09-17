//
//  ContentView.swift
//  SipTest
//
//  Created by Bilal Mehdi on 02/09/2024.
//
//
//import SwiftUI
//import linphonesw
//
//
//struct ContentView: View {
//    var body: some View {
//          TabView {
////              IncomingCallView()
////                  .tabItem {
////                      Image(systemName: "phone.arrow.down.left.fill")
////                      Text("Incoming Call")
////                  }
//
//              OutgoingCallView()
//                  .tabItem {
//                      Image(systemName: "phone.arrow.up.right.fill")
//                      Text("Outgoing Call")
//                  }
//          }
//      }
//  }
//
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = OutgoingCall.shared
    @ObservedObject var incomingCall = IncomingCall.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SIP Call Test")
                .font(.largeTitle)
                .padding()
            
            // Display call status message
            if model.isCallRunning {
                Text("Call started")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            } else {
                Text("No call in progress")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Start Call button (always visible)
            Button(action: {
                
                model.login()
                model.makeCall()  // Start the call when pressed
            }) {
//                Text("Start Call")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(8)
                Image(systemName: "phone.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            // End Call button (always visible)
            Button(action: {
                model.terminateCall() // End the call when pressed
            }) {
                Text("End Call")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
