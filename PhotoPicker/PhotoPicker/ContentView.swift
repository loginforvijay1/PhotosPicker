//
//  ContentView.swift
//  PhotoPicker
//
//  Created by Vemireddy Vijayasimha Reddy on 30/03/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var images: [UIImage] = []
    @State private var photosPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            
            PhotosPicker("Select photos", selection: $photosPickerItems, maxSelectionCount: 5,selectionBehavior: .ordered)
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(0..<images.count, id: \.self) { i in
                        Image(uiImage: images[i])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(.circle)
                    }
                }
            }
        }
        .padding(30)
        .onChange(of: photosPickerItems) { _, _ in
            Task {
                for item in photosPickerItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            images.append(image)
                        }
                    }
                    photosPickerItems.removeAll()
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
