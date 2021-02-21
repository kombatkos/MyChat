//
//  ProfileViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.02.2021.
//

import UIKit
import SwiftyBeaver

class ProfileViewController: UIViewController {
    
    //Properties
    
    let firstName = "Marina"
    let lastName = "Dudarenko"
    
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var containerAvatarView: UIView?
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var aboutMeLabel: UILabel?
    
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var firstWordOfName: UILabel?
    @IBOutlet weak var firstWordOfLastName: UILabel?
    
    @IBOutlet weak var editButton: UIButton? {
        didSet {
//             print(#function, editButton?.bounds ?? " editButton?.frame == nil")
            // тут editButton получает размеры из interfaseBuilder, но координаты местоположения пока x:0, y:0
        }
    }
    
    @IBOutlet weak var leadingContainerConstraint: NSLayoutConstraint?
    @IBOutlet weak var trailingContainerConstraint: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        print(#function, editButton?.bounds ?? " editButton?.frame == nil")
    // Свойство frame является вычислимым, размеры всех subviews еще не определены
    // IBOutlets инициализируются после метода super.init()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function, editButton?.frame ?? " editButton?.frame == nil")
        
        setProfile()
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerAvatarViewTapped))
        containerAvatarView?.addGestureRecognizer(tap)
        
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            updateConstraintForBigScreen()
        }
        setUI()
        // Здесь размеры subviews уже известны.
        // Тут можно задать, например, вычисляемый cornerRadius
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function, editButton?.frame ?? " editButton?.frame == nil")
        // Размеры subviews становятся известны после того как self.view примет свои размеры.
        // В методе viewDidLoad размеры view загружаются из InterfaceBuilder.
        // Далее размеры subviews компонуются в методе viewWillLayoutSubviews.
        // В методе viewDidLayoutSubviews размеры subviews уже известны.
        // Метод viewDidAppear показывает нам уже готовые views
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func containerAvatarViewTapped() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
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
    
    private func setUI() {
        setFontForLabels()
        
        if view.bounds.width > view.bounds.height {
            profileStackView.axis = .horizontal
            profileStackView.distribution = .fillEqually
        } else {
            profileStackView.axis = .vertical
            profileStackView.distribution = .fill
        }
        
        editButton?.layer.cornerRadius = 14
        guard let avatarViewWidth = containerAvatarView?.frame.width else { return }
        containerAvatarView?.layer.cornerRadius = avatarViewWidth / 2
        containerAvatarView?.clipsToBounds = true
    }
    
    private func updateConstraintForBigScreen() {
        
        leadingContainerConstraint?.constant = 120
        trailingContainerConstraint?.constant = 120
    }
}

//MARK: Work with image
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        avatarImageView?.image = info[.editedImage] as? UIImage
        avatarImageView?.contentMode = .scaleAspectFill
        avatarImageView?.clipsToBounds = true
        
        
        dismiss(animated: true)
    }
}
