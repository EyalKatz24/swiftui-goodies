//
//  FlashlightToggleStyle.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI
import AVFoundation

@available(iOS 17.0, *)
fileprivate struct FlashlightToggleStyle: ToggleStyle {

    private let imageRatio = 0.5
    
    private var device: AVCaptureDevice? { .userPreferredCamera }
    
    private var isTorchAvailable: Bool { device?.hasTorch == true && device?.isTorchAvailable == true }
    
    func makeBody(configuration: Configuration) -> some View {
        if isTorchAvailable {
            GeometryReader { geometry in
                Button {
                    toggleTorch(configuration.$isOn)
                } label: {
                    Circle()
                        .modify { circle in
                            if configuration.isOn {
                                circle.fill(.white.opacity(0.85))
                            } else {
                                circle.fill(.ultraThinMaterial)
                            }
                        }
                        .overlay {
                            Image(systemName: configuration.isOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * imageRatio, height: geometry.size.height * imageRatio)
                                .foregroundStyle(configuration.isOn ? .indigo : .white)
                                .accessibilityHidden(true)
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func toggleTorch(_ isOn: Binding<Bool>) {
        guard let device else { return }
        
        do {
            try device.lockForConfiguration()
            isOn.wrappedValue.toggle()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            if isOn.wrappedValue {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch { }
    }
}

@available(iOS 17.0, *)
extension ToggleStyle where Self == FlashlightToggleStyle {
    
    static var flashlight: Self { FlashlightToggleStyle() }
}

@available(iOS 17.0, *)
struct FlashlightButton: View {
    @State private var isOn = false
    
    var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(.flashlight)
    }
}
