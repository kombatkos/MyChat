//  ProfileViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.02.2021.

import UIKit

class ProfileViewController: EmitterViewController {
    // MARK: - Properties
    // Dependenses
    var palette: PaletteProtocol?
    var profileService: ISaveProfileService?
    var delegate: ConversationListVCDelegate?
    
    var clousure: ((UIImage) -> (UIImage))?
    var profile: Profile?
    var avatarImageViewChanged: Bool = false {
        didSet { blockingSaveButtons(isBlocked: false) }
    }
    var imagePicker: IImagePicker?
    
    // MARK: - IBOutlets
    @IBOutlet weak var navigationView: UIView?
    @IBOutlet weak var editButtonSmall: AnimatedButton?
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
        loadData(profileService)
        aboutTextView?.delegate = self
        nameTextField?.delegate = self
        view.backgroundColor = palette?.backgroundColor ?? .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerAvatarViewTapped))
        containerAvatarView?.addGestureRecognizer(tap)
        
        blockingSaveButtons(isBlocked: true)
        textEditing(isEditing: false)
        aboutTextView?.accessibilityIdentifier = "value"
        nameTextField?.accessibilityIdentifier = "value"
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
        var shouldLogTextAnalyzer = false
        if ProcessInfo.processInfo.environment["deinit_log"] == "verbose" {
            shouldLogTextAnalyzer = true
        }
        if shouldLogTextAnalyzer { print("Deinit ProfileViewController") }
    }
    
    // MARK: - UI behavior
    func blockingSaveButtons(isBlocked: Bool) {
        saveButton?.isEnabled = !isBlocked
    }
    
    func textEditing(isEditing: Bool) {
        aboutTextView?.keyboardAppearance = palette?.keyboardStyle ?? .light
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
    
    @IBAction func smallEditButtonTapped(_ sender: AnimatedButton) {
        if sender.isAnimated {
            cancelButtonTapped(sender)
        } else {
            sender.startAnimation()
            textEditing(isEditing: true)
            nameTextField?.becomeFirstResponder()
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        editButtonSmall?.jiggle()
        textEditing(isEditing: true)
        nameTextField?.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        editButtonSmall?.stopAnimation()
        textEditing(isEditing: false)
        profileService?.cancel()
        blockingSaveButtons(isBlocked: true)
        loadData(profileService)
    }
    
    @IBAction func saveOperationTapped(_ sender: UIButton) {
        editButtonSmall?.stopAnimation()
        let profile = getProfile()
        self.profile = profile
        saveData(profileService, profile: profile)
        blockingSaveButtons(isBlocked: true)
    }
    
    @objc func containerAvatarViewTapped(_ sender: UIButton) {
        if let aminated = editButtonSmall?.isAnimated, !aminated {
            editButtonSmall?.jiggle()
        }
        imagePicker?.present(from: sender)
        textEditing(isEditing: true)
    }
    
    // MARK: - Work data
    private func loadData(_ profileService: ISaveProfileService?) {
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
    
    private func saveData(_ profileService: ISaveProfileService?, profile: Profile) {
        
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
            image = nil } else { image = avatarImageView?.image }
        
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
        navigationView?.backgroundColor = color
    }
    private func setPlaceholder() {
        nameTextField?.backgroundColor = .clear
        nameTextField?.attributedPlaceholder = NSAttributedString(string: "My name", attributes: [NSAttributedString.Key.foregroundColor: palette?.placeHolderColor ?? .lightGray])
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
extension ProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        avatarImageView?.image = image
        avatarImageView?.contentMode = .scaleAspectFill
        avatarImageView?.clipsToBounds = true
        avatarImageViewChanged = true
    }
}
