//
//  ProfileViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.02.2021.
//

import UIKit
import SwiftyBeaver
import AVFoundation

class ProfileViewController: UIViewController {
    
// MARK: - Properties
    
    let firstName = "Marina"
    let lastName = "Dudarenko"
    
    @IBOutlet weak var containerAvatarView: AvatarView?
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var firstWordOfName: UILabel?
    @IBOutlet weak var firstWordOfLastName: UILabel?
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var aboutMeLabel: UILabel?
    
    @IBOutlet weak var editButton: UIButton?
    @IBOutlet weak var trailingConstraintForContainerView: NSLayoutConstraint?
    @IBOutlet weak var leadingConstraintForContainerView: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemesManager.currentTheme().backgroundColor
        
        setProfile()
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerAvatarViewTapped))
        containerAvatarView?.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        editButton?.layer.cornerRadius = 14
        setFontForLabels()
        if UIDevice.current.userInterfaceIdiom == .pad {
            trailingConstraintForContainerView?.constant = 170
            leadingConstraintForContainerView?.constant = 170
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func containerAvatarViewTapped() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            actionSheet.overrideUserInterfaceStyle = ThemesManager.currentTheme().alertStyle
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
        actionSheet.popoverPresentationController?.sourceView = containerAvatarView
        present(actionSheet, animated: true)
    }
    
    private func setProfile() {
        nameLabel?.text = "\(firstName) \(lastName)"
        firstWordOfName?.text = firstName.first?.uppercased()
        firstWordOfLastName?.text = lastName.first?.uppercased()
    }
    
    
}

// MARK: - Settup UI

extension ProfileViewController {
    
    private func setFontForLabels() {
        guard let avatarViewWidth = containerAvatarView?.frame.width else { return }
        nameLabel?.font = UIFont.boldSystemFont(ofSize: avatarViewWidth / 10)
        aboutMeLabel?.font = UIFont.systemFont(ofSize: avatarViewWidth / 16)
        firstWordOfName?.font = UIFont.systemFont(ofSize: avatarViewWidth / 2)
        firstWordOfLastName?.font = UIFont.systemFont(ofSize: avatarViewWidth / 2)
    }
}

// MARK: - Work with image

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                present(imagePicker, animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        avatarImageView?.image = info[.editedImage] as? UIImage
        avatarImageView?.contentMode = .scaleAspectFill
        avatarImageView?.clipsToBounds = true
        
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
        let settingAction = UIAlertAction(title: "Settings", style: .default) { value in
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
