//
//  ContentView.swift
//  BusinessCard
//
//  Created by yosef ulman on 3/18/24.
//

import SwiftUI
import PhotosUI


struct ContentView: View {
    @State var nameText: String = ""
    @State var titleText: String =  ""
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    var body: some View {
        NavigationView() {
            ZStack {
                Color(uiColor: .yellow)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    ZStack {
                        Capsule()
                            .frame(height: 50)
                            .foregroundColor(.green)
                        TextField("Name", text: $nameText)
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.system(size: 30))
                    }
                    .padding(.horizontal)
                    ZStack {
                        Capsule()
                            .frame(height: 50)
                            .foregroundStyle(.green)
                        TextField("Title", text: $titleText)
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.system(size: 30))
                        }
                    .padding(.horizontal)
                    ZStack {
                        Capsule()
                            .frame(height: 50)
                            .foregroundColor(.orange)
                        PhotosPicker("Select Image", selection: $avatarItem, matching: .images)
                            .font(.system(size: 30))
                            .foregroundStyle(.black)
                        
                    }
                    .padding(.horizontal)
                    NavigationLink(destination: insideView(name: nameText, title: titleText, image: avatarImage ?? Image(systemName: "person.circle"))) {
                        ZStack {
                            Capsule()
                                .frame(height: 50)
                                .foregroundStyle(.orange)
                            Text("Create Business Card")
                                .multilineTextAlignment(.center)
                                .padding()
                                .font(.system(size: 30))
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal)
                    }
                    .onChange(of: avatarItem) {
                        Task {
                            if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                                avatarImage = loaded
                            } else {
                                print("Failed")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct insideView: View  {
    let name: String
    let title: String
    let image: Image
    
    var body: some View {
        ZStack {
            Color(uiColor: .orange)
                .edgesIgnoringSafeArea(.all)
            VStack {
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(lineWidth: 5)
                        .foregroundStyle(.white))
                Text(name)
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Text(title)
                    .foregroundStyle(.white)
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
            }
        }
    }

}


struct ImageView: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?

    var body: some View {
        VStack {
            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)

            avatarImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
        .onChange(of: avatarItem) {
            Task {
                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                    avatarImage = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
