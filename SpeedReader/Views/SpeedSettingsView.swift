//
//  SpeedSettingsView.swift
//  SpeedReader
//
//  Created by Sardorbek Saydamatov on 14/11/24.
//

import SwiftUI

struct SpeedSettingsView: View {
    @Binding var speed: Int
    var speedOptions: [Int]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                
                Picker("Speed", selection: $speed) {
                    ForEach(speedOptions, id: \.self) { option in
                        Text("\(option) WPM").tag(option)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
            }
            .navigationTitle("Choose speed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SpeedSettingsView(speed: .constant(200), speedOptions: [100, 200, 300, 400, 500])
}
