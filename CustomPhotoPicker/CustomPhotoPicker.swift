//
//  PhotoPickerComp.swift
//  MealMatch_Client_iOS
//
//  Created by Arjun Doel on 08/05/2023.
//

import SwiftUI
import PhotosUI

struct PhotoPickerComp: View {
    @Binding var selectedImage: UIImage?
    @State var data: PhotosPickerItem?
    @State private var animateDelete = false
    
    var width: CGFloat
    var height: CGFloat
    
    var onError: (String) -> ()
    
    
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
                .shadow(radius: 0.6)
                
                deleteButton
                    .offset(x: 10, y: -10)
            }
        }
        .onChange(of: data) { _ in
            Task {
                await handleImageSelect()
            }
        }
    }
    
    var imagePlaceholder: some View {
        VStack(alignment: .center) {
            Image(systemName: "camera.fill")
                .font(.title)
                .foregroundColor(.gray)
        }
        .frame(width: width, height: height)
        .background(.thickMaterial)
    }
    
    var deleteButton: some View {
        VStack {
            ZStack {
                VStack {
                    
                }
                .frame(width: 40, height: 40)
                .background(.red)
                .mask(Circle())
                
                Image(systemName: "multiply")
                    .fontWeight(.bold)
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
        PhotoPickerComp(selectedImage: .constant(nil), width: 200, height: 500) { message in
            print(message)
        }
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
    
    @MainActor
    private func handleImageSelect() async {
        if let data = try? await self.data?.loadTransferable(type: Data.self) {
            if let uiImage = UIImage(data: data) {
                self.selectedImage = uiImage
                return
            }
        } else {
            onError("Could not load image")
        }
        
        print("Failed")
    }
}

