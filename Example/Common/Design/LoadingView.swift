//
//  LoadingView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

public struct LoadingView: View {
    
    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
                .tint(.blue)
            
            Text("Loading ...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}
