//
//  ContentView.swift
//  CustomPhotoPicker
//
//  Created by Arjun Doel on 09/05/2023.
//

import SwiftUI

import SwiftUI
import PhotosUI

struct PhotoPickerComp: View {
    @Binding var data: PhotosPickerItem?
    @Binding var selectedImage: UIImage?
    @State private var animateDelete = false
    
    var width: CGFloat
    var height: CGFloat
    
    
    var body: some View {
        PhotosPicker(selection: $data, matching: .images) {
            
            ZStack(alignment: .topTrailing) {
                VStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        imagePlaceholder
                    }
                }
                .frame(width: width, height: height)
                .mask(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 1)
                
                deleteButton
                    .offset(x: 10, y: -10)
            }
        }
    }
    
    var imagePlaceholder: some View {
        VStack {}
            .frame(width: width, height: height)
            .background(.thickMaterial)
    }
    
    var deleteButton: some View {
        VStack {
            ZStack {
                VStack {
                    
                }
                .frame(width: 50, height: 50)
                .background(.red)
                .mask(Circle())
                
                Image(systemName: "trash.slash.fill")
                    .tint(.white)
                
            }
            .scaleEffect(animateDelete ? 1.2 : 1)
            .onTapGesture {
                setAnimateDelete()
                self.selectedImage = nil
            }
        }
    }
}

struct PhotoPickerComp_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerComp(data: .constant(nil),
                        selectedImage: .constant(nil),
                        width: 200, height: 500
        )
    }
}

extension PhotoPickerComp {
    private func setAnimateDelete() {
        withAnimation(.easeIn) {
            self.animateDelete = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeIn) {
                self.animateDelete = false
            }
        }
    }
}
