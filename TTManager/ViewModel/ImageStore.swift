//
//  ImageStore.swift
//  TTManager
//
//  Created by Alex Wecker on 27/12/2021.
//

import SwiftUI
import CoreData

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    var store: ImageStore
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: ImagePickerView
        
        init(picker: ImagePickerView) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.store.saveImage(image: selectedImage)
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
    }
}

struct ImageStore {
    
    @Binding var club: Club
    
    func loadImage(imageName: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(imageName).path)
            return image
        }
        return nil
    }
    
    mutating func saveImage(image: UIImage) {
        //save the image as png
        guard let data = image.jpegData(compressionQuality: 0.7) ?? image.pngData() else {return}
        //get the apps directory
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {return}
        //get the current Time to get a new file name
        let filename = Date.init().description+".png"
        do {
            //save the image
            try data.write(to: directory.appendingPathComponent(filename)!)
            //save the image name in the club so that it can be found later
            if (club.images!.components(separatedBy: ",") == [""]) {
                club.images! = filename
            }else{
                club.images!.append(",")
                club.images?.append(filename)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
