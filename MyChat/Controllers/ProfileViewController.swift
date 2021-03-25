//
//  ProfileViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.02.2021.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    // MARK: - Properties
    
    // Dependenses
    var palette: PaletteProtocol?
    var profileService: ProfileService?
    var profile: Profile?
    weak var delegate: ConversationListVCDelegate?
    
    var avatarImageViewChanged: Bool = false {
        didSet { blockingSaveButtons(isBlocked: false) }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var containerAvatarView: AvatarView?
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var firstWordOfName: UILabel?
    @IBOutlet weak var firstWordOfLastName: UILabel?
    
    @IBOutlet weak var editButton: UIButton?
    @IBOutlet weak var trailingConstraintForContainerView: NSLayoutConstraint?
    @IBOutlet weak var leadingConstraintForContainerView: NSLayoutConstraint?
    
    @IBOutlet weak var saveBar: UIView?
    @IBOutlet weak var cancelButton: UIButton?
    @IBOutlet weak var saveButton: UIButton?
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var aboutTextView: UITextView?
    
    @IBOutlet weak var distanceBetweenTextviewAndButton: NSLayoutConstraint?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotification()
        loadData(SaveProfileService(fileManager: FilesManager()))
        aboutTextView?.delegate = self
        nameTextField?.delegate = self
        palette = ThemesManager.currentTheme()
        view.backgroundColor = palette?.backgroundColor ?? .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerAvatarViewTapped))
        containerAvatarView?.addGestureRecognizer(tap)
        
        blockingSaveButtons(isBlocked: true)
        textEditing(isEditing: false)
    }
    
    override func viewDidLayoutSubviews() {
        setFontForLabels()
        setProfile()
        setPlaceholder()
    }
    
    deinit {
        removeForKeyboardNotification()
        profileService?.cancel()
        delegate?.setProfileButton()
    }
    
    // MARK: - UI behavior
    
    func blockingSaveButtons(isBlocked: Bool) {
        saveButton?.isEnabled = !isBlocked
    }
    
    func textEditing(isEditing: Bool) {
        nameTextField?.isEnabled = isEditing
        aboutTextView?.isEditable = isEditing
        editButton?.isHidden = isEditing
        saveBar?.isHidden = !isEditing
        if isEditing {
            distanceBetweenTextviewAndButton?.constant = -70
        } else {
            distanceBetweenTextviewAndButton?.constant = +70
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        textEditing(isEditing: true)
        nameTextField?.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        textEditing(isEditing: false)
        profileService?.cancel()
        blockingSaveButtons(isBlocked: true)
        loadData(profileService)
    }
    
    @IBAction func saveOperationTapped(_ sender: UIButton) {
        profileService = SaveProfileService(fileManager: FilesManager())
        let profile = getProfile()
        self.profile = profile
        saveData(profileService, profile: profile)
        blockingSaveButtons(isBlocked: true)
    }
    
    @objc func containerAvatarViewTapped() {
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
        actionSheet.popoverPresentationController?.sourceView = containerAvatarView
        present(actionSheet, animated: true)
        
        textEditing(isEditing: true)
    }
    
    // MARK: - Work data
    
    private func loadData(_ profileService: ProfileService?) {
        let profileService = profileService
        profileService?.loadProfile(completion: { [weak self] profile in
            self?.nameTextField?.text = profile?.name
            self?.aboutTextView?.text = profile?.aboutMe
            
            // image logic
            if profile?.name == "" && profile?.avatarImage == nil || profile?.name == nil
                && profile?.avatarImage == nil {
                self?.avatarImageView?.image = #imageLiteral(resourceName: "default-avatar")
            } else {
                self?.avatarImageView?.image = profile?.avatarImage
            }
            
            // set placeholder
            if profile?.aboutMe == "" || profile?.aboutMe == nil {
                self?.aboutTextView?.text = "About me..."
                self?.aboutTextView?.textColor = UIColor.lightGray
            }
            
            // set activity indicator
            self?.activityIndicator?.isHidden = true
            self?.activityIndicator?.stopAnimating()
            
            // initials of the name logic
            guard let fullNameArr = profile?.name?.split(separator: " ") else { return }
            if fullNameArr.count > 0 && profile?.avatarImage == nil {
                let firstWord = fullNameArr[0].first
                self?.firstWordOfName?.text = String(firstWord ?? "?")
                self?.avatarImageView?.image = nil
            } else {
                self?.firstWordOfName?.text = ""
            }
            if fullNameArr.count > 1 {
                let firstWord = fullNameArr[1].first
                self?.firstWordOfLastName?.text = String(firstWord ?? "?")
            } else {
                self?.firstWordOfLastName?.text = ""
            }
        })
    }
    
    private func saveData(_ profileService: ProfileService?, profile: Profile) {
        
        profileService?.saveProfile(profile: profile, completion: { [weak self] isSaved in
            self?.showAlert(isSaved: isSaved)
            self?.loadData(profileService)
            self?.textEditing(isEditing: false)
        })
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    private func getProfile() -> Profile {
        var image: UIImage?
        if avatarImageView?.image == #imageLiteral(resourceName: "default-avatar") || !avatarImageViewChanged {
            image = nil
        } else {
            image = avatarImageView?.image
        }
        let about = aboutTextView?.text == "About me..." ? "" : aboutTextView?.text
    
        let profile = Profile(name: nameTextField?.text,
                              aboutMe: about,
                              avatarImage: image)
        return profile
    }
}

// MARK: - Settup UI

extension ProfileViewController {
    
    private func setFontForLabels() {
        guard let avatarViewWidth = containerAvatarView?.frame.width else { return }
        let fontSizeAboutMeLabel = avatarViewWidth / 16
        let fontSizeInitiales = avatarViewWidth / 2
        aboutTextView?.font = UIFont.systemFont(ofSize: fontSizeAboutMeLabel)
        firstWordOfName?.font = UIFont.systemFont(ofSize: fontSizeInitiales)
        firstWordOfLastName?.font = UIFont.systemFont(ofSize: fontSizeInitiales)
        aboutTextView?.font = UIFont.systemFont(ofSize: fontSizeAboutMeLabel)
    }
    
    private func setProfile() {
        firstWordOfName?.textColor = .black
        firstWordOfLastName?.textColor = .black
        setCornerRadiusForButtons()
        setButtonsColor()
    }
    
    private func setCornerRadiusForButtons() {
        let radius: CGFloat = 14
        editButton?.layer.cornerRadius = radius
        saveButton?.layer.cornerRadius = radius
        cancelButton?.layer.cornerRadius = radius
    }
    
    private func setButtonsColor() {
        let color = palette?.buttonColor
        editButton?.backgroundColor = color
        saveButton?.backgroundColor = color
        cancelButton?.backgroundColor = color
    }
}

// MARK: - UITextViewDelegate, UITextFieldDelegate
extension ProfileViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = palette?.labelColor
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        blockingSaveButtons(isBlocked: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            aboutTextView?.text = "About me..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        blockingSaveButtons(isBlocked: false)
        return true
    }
}

// MARK: - PlaceHolders
extension ProfileViewController {
    
    private func setPlaceholder() {
        nameTextField?.backgroundColor = .clear
        nameTextField?.attributedPlaceholder = NSAttributedString(string: "My name", attributes: [NSAttributedString.Key.foregroundColor: palette?.placeHolderColor ?? .lightGray])
    }
}

// MARK: - Alert Controller
extension ProfileViewController {
    
    private func showAlert(isSaved: Bool) {
        guard let profile = self.profile else { return }
        blockingSaveButtons(isBlocked: true)
        
        let saved = UIAlertController(title: "Data saved", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        saved.addAction(ok)
        
        let nonSaved = UIAlertController(title: "Error", message: "Failed to save data", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) 
        let repeatButton = UIAlertAction(title: "Repeat", style: .cancel) { [weak self] _ in
            self?.saveData(self?.profileService, profile: profile)
        }
        
        nonSaved.addAction(okButton)
        nonSaved.addAction(repeatButton)
        
        if isSaved {
            present(saved, animated: true)
        } else {
            present(nonSaved, animated: true)
        }
    }
}
