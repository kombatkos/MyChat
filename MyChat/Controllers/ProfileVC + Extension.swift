//
//  ProfileVC + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.03.2021.
//

import UIKit
import AVFoundation

// MARK: - Work with image

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            if source == .camera {
                imagePicker.cameraDevice = .front
                checkCamera(imagePicker: imagePicker)
            } else if source == .photoLibrary {
                present(imagePicker, animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        avatarImageView?.image = info[.editedImage] as? UIImage
        avatarImageView?.contentMode = .scaleAspectFill
        avatarImageView?.clipsToBounds = true
        avatarImageViewChanged = true
        
        dismiss(animated: true)
    }
    
    private func checkCamera(imagePicker: UIImagePickerController) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: present(imagePicker, animated: true)
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: present(imagePicker, animated: true)
        case .restricted: print("Camera - restricted")
        @unknown default:
            return
        }
    }

    private func alertToEncourageCameraAccessInitially() {
        let alertVC = UIAlertController(title: "Access to the camera is closed", message: "Open Settings/MyChats and enable camera access", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: "Settings", style: .default) { _ in
            let path = UIApplication.openSettingsURLString
            if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        alertVC.addAction(settingAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }

}
