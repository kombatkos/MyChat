//
//  ImagePicker.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import UIKit
import AVFoundation

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

protocol IImagePicker {
    func present(from sourceView: UIView)
}

open class ImagePicker: NSObject, IImagePicker {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private var palette: PaletteProtocol?

    init(presentationController: UIViewController, delegate: ImagePickerDelegate, palette: PaletteProtocol?) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
        
        self.palette = palette
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")

        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            actionSheet.overrideUserInterfaceStyle = palette?.alertStyle ?? .light
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }

        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)

        actionSheet.pruneNegativeWidthConstraints()

        self.presentationController?.present(actionSheet, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            if source == .camera {
                imagePicker.cameraDevice = .front
                checkCamera(imagePicker: imagePicker)
            } else if source == .photoLibrary {
                presentationController?.present(imagePicker, animated: true)
            }
        }
    }
    
    private func checkCamera(imagePicker: UIImagePickerController) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: presentationController?.present(imagePicker, animated: true)
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: presentationController?.present(imagePicker, animated: true)
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
        presentationController?.present(alertVC, animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
