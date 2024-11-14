//
//  ContentView.swift
//  SpeedReader
//
//  Created by Sardorbek Saydamatov on 14/11/24.
//

import SwiftUI

struct SpeedReaderView: View {
    @State private var text = "This is a sample text for speed reading. You can adjust the speed and control the reading flow."
    @State private var words: [String] = []
    @State private var currentWordIndex = 0
    @State private var isReading = false
    @State private var isPaused = false
    @State private var speed: Int = 200
    @State private var showSettings = false
    @State private var timer: Timer?
    
    let speedOptions = [100, 200, 300, 400, 500, 600, 700, 800]
    var body: some View {
        VStack {
            Spacer()
            wordSection
            Spacer()
            buttonsSection
            .padding()
            
            speedControlSection
        }
        .sheet(isPresented: $showSettings) {
            SpeedSettingsView(speed: $speed, speedOptions: speedOptions)
                .presentationDetents([.fraction(0.3)])
        }
        .onAppear {
            words = text.split(separator: " ").map { String($0) }
        }
        .onDisappear {
            stopReading()
        }
    }
}

extension SpeedReaderView {
    private var wordSection: some View {
        Text(currentWordIndex < words.count ? words[currentWordIndex] : "")
            .font(.largeTitle)
    }
    
    private var buttonsSection: some View {
        HStack {
            Button(action: toggleReading) {
                Text(isReading ? "Stop" : "Start")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .background(isReading ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            
            Button(action: togglePause) {
                Text(isPaused ? "Resume" : "Pause")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .background(isPaused ? Color.orange : Color.blue)
                    .cornerRadius(10)
                    .disabled(!isReading)
            }
        }
    }
    
    private var speedControlSection: some View {
        HStack {
            Text("Speed: \(speed) WPM")
            
            Button(action: {
                showSettings.toggle()
                stopReading()
            }) {
                Text("\(speed)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .frame(width: 80, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary.opacity(0.3))
                    )
            }
            .padding()
        }
    }
    
    // MARK: Helper methods
    private func toggleReading() {
        if isReading {
            stopReading()
        } else {
            startReading()
        }
    }
    
    private func togglePause() {
        isPaused.toggle()
        if isPaused {
            timer?.invalidate()
        } else {
            startReading()
        }
    }
    
    private func startReading() {
        isReading = true
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 60.0 / Double(speed), repeats: true) { _ in
            showNextWord()
        }
    }
    
    private func stopReading() {
        isReading = false
        isPaused = false
        timer?.invalidate()
        currentWordIndex = 0
    }
    
    private func showNextWord() {
        if currentWordIndex < words.count - 1 {
            currentWordIndex += 1
        } else {
            stopReading()
        }
    }
}

#Preview(body: {
    SpeedReaderView()
})
