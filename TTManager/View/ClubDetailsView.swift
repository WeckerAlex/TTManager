//
//  ClubDetailsView.swift
//  TTManager
//
//  Created by Alex Wecker on 25/12/2021.
//

import SwiftUI
import UIKit


struct ClubDetailsView: View {
    
    @State var club: Club
    @EnvironmentObject var dataController: DataController
    @Binding var isShowing: Bool
    @State var showcamera: Bool = false
    @State var isDeletePopupShowing = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var newImage: UIImage?
    
    @State private var isImagePickerDisplay = false
    @State private var iscameraDisplayed = false
    
    @State private var displayedImageIndex: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            Text(club.name!).font(.headline).padding()
            
            Form {
                Section {
                    HStack {
                        Text("Phone number")
                        Spacer()
                        Image(systemName: "phone")
                            .onTapGesture {
                                print("phone \(club.phonenumber!)")
                                guard let url = URL(string: "tel://\(club.phonenumber!)") else {return}
                                UIApplication.shared.open(url)
                            }
                    }
                    Text(club.phonenumber!)
                }
                Section {
                    Text("Address")
                    Text(club.address!)
                }
                Section {
                    HStack {
                        Text("Images")
                        Spacer()
                        Button(action: {
                            isImagePickerDisplay = true
                        }, label: {
                            Image(systemName: "plus.circle")
                        })
                        .actionSheet(isPresented: $isImagePickerDisplay) {
                            ActionSheet(title: Text("Image Selector"),
                                        message: Text("Choose an image source"),
                                        buttons: [
                                            .default(
                                                Text("Camera"),
                                                action: {
                                                    self.sourceType = .camera
                                                    showcamera = true
                                                }
                                            ),
                                            .default(
                                                Text("Gallery"),
                                                action: {
                                                    self.sourceType = .photoLibrary
                                                    showcamera = true
                                                }
                                            ),
                                            .cancel()
                                        ]
                            )
                        }
                    }
                    HStack {
                        Button(action: {
                            if !(club.images!.components(separatedBy: ",") == [""]) {
                                if self.displayedImageIndex == nil {
                                    self.displayedImageIndex = 0;
//                                        getImage(position: 0)
                                }else{
                                    self.displayedImageIndex = max(self.displayedImageIndex!-1, 0)
//                                        getImage(position: max(displayedImageIndex!-1, 0))
                                }
                            }
                        }, label: {
                            Image(systemName: "chevron.left")
                                .font(Font.system(.body).weight(.bold))
                        })
                            .buttonStyle(BorderlessButtonStyle())
                        if self.displayedImageIndex != nil {
                            Image(uiImage: getImage(position: self.displayedImageIndex!))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .onLongPressGesture {
                                    isDeletePopupShowing = true
                                }
                                .alert(isPresented: $isDeletePopupShowing){
                                    Alert(title: Text("Delete Image"),
                                          message: Text("Do you want to delete this image?"),
                                          primaryButton: .default(Text("Ok")){
                                            removeImage()
                                          },
                                          secondaryButton: .cancel()
                                    )
                                }
                        } else {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        Button(action: {
                            if !(club.images!.components(separatedBy: ",") == [""]) {
                                if self.displayedImageIndex == nil {
                                    self.displayedImageIndex = club.images!.components(separatedBy: ",").count-1
//                                     getImage(position: displayedImageIndex!)
                                }else{
                                    self.displayedImageIndex = min(self.displayedImageIndex!+1, club.images!.components(separatedBy: ",").count-1)
//                                        getImage(position: min(displayedImageIndex!+1, club.images.count-1))
                                }
                            }
                        }, label: {
                            Image(systemName: "chevron.right")
                                .font(Font.system(.body).weight(.bold))
                        })
                        .buttonStyle(BorderlessButtonStyle())
                    }.onAppear(perform: {
                        if !(club.images!.components(separatedBy: ",") == [""]) {
                            self.displayedImageIndex = 0;
                        }
                    })
                }
            }
        }
        .popover(isPresented: $showcamera){
            ImagePickerView(sourceType: self.sourceType,store: ImageStore(club: $club))
                .onDisappear(
                    perform: {
                        dataController.saveData()
                        if (displayedImageIndex == nil && club.images!.components(separatedBy: ",").count != 0 ){
                            displayedImageIndex = 0
                        }
                    }
                )
        }
        .navigationBarItems(trailing:Button(action: {self.isShowing = false}, label: { Text("Done") }))
    }
    
    func getImage(position: Int) -> UIImage {
        let store = ImageStore(club: $club)
        print("Loading position " + position.description)
        print(club.images!.components(separatedBy: ","))
        return store.loadImage(imageName: club.images!.components(separatedBy: ",")[position])!
    }
    
    func removeImage() {
        var imagearray = club.images!.components(separatedBy: ",")
        imagearray.remove(at: displayedImageIndex!)
        club.images = imagearray.joined(separator: ",")
        displayedImageIndex = (displayedImageIndex != 0) ? displayedImageIndex!-1 : nil
    }
}
