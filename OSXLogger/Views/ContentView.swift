//
//  ContentView.swift
//  OSXLogger
//
//  Created by standard on 2/26/23.
//

import SwiftUI


import SwiftUI
import ScreenCaptureKit
import OSLog
import Combine

struct ContentView: View {
    
    @State var userStopped = false
    @State var disableInput = false
    @State var isUnauthorized = false
    
    @StateObject var screenRecorder = ScreenRecorder()
    
    var body: some View {
        let previewScale = 0.2
        ZStack (alignment: .bottomTrailing) {


            screenRecorder.capturePreview
                .border(Color.green)
                .frame(maxWidth: screenRecorder.contentSize.width*previewScale, maxHeight: screenRecorder.contentSize.height*previewScale)
                .aspectRatio(screenRecorder.contentSize, contentMode: .fit)
                .padding(8)
                .overlay {
                    if userStopped {
                        Image(systemName: "nosign")
                            .font(.system(size: 250, weight: .bold))
                            .foregroundColor(Color(white: 0.3, opacity: 1.0))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(white: 0.0, opacity: 0.5))
                    }
                }
                .opacity(0.4)
               
            DisplayListLayoutView(screenRecorder: screenRecorder)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .overlay {
            if isUnauthorized {
                VStack() {
                    Spacer()
                    VStack {
                        Text("No screen recording permission.")
                            .font(.largeTitle)
                            .padding(.top)
                        Text("Open System Settings and go to Privacy & Security > Screen Recording to grant permission.")
                            .font(.title2)
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    
                }
            }
        }
        .navigationTitle("Screen Capture Sample")
        .onAppear {
            Task {
                if await screenRecorder.canRecord {
                    await screenRecorder.start()
                } else {
                    isUnauthorized = true
                    disableInput = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
