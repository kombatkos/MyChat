//
//  ThemesViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 04.03.2021.
//

import UIKit

protocol ThemesPickerDelegate {
    func changeThemeWorkDelegate(theme: Theme) -> Theme
}

class ThemesViewController: EmitterViewController {
    
    var delegate: ThemesPickerDelegate?
    var clousure: ((Theme) -> (Theme))?
    
    // Dependenses
    var lastTheme: PaletteProtocol?
    var palette: PaletteProtocol?
    
    // Properties
    private let classicView = ThemeButtonView()
    private let dayView = ThemeButtonView()
    private let nightView = ThemeButtonView()
    private let colors = Colors()
    
    init(palette: PaletteProtocol?) {
        self.palette = palette
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lastTheme == nil { lastTheme = palette }
        view.backgroundColor = palette?.bubbleRightColor ?? .brown
        title = "Settings"
        setSubviews()
        setCancelButton()
        
        let tapClassicTheme = UITapGestureRecognizer(target: self, action: #selector(classicThemeAction))
        let tapDayTheme = UITapGestureRecognizer(target: self, action: #selector(dayThemeAction))
        let tapNightTheme = UITapGestureRecognizer(target: self, action: #selector(nightThemeAction))
        classicView.addGestureRecognizer(tapClassicTheme)
        dayView.addGestureRecognizer(tapDayTheme)
        nightView.addGestureRecognizer(tapNightTheme)
    }
    
    deinit {
        var shouldLogTextAnalyzer = false
        if ProcessInfo.processInfo.environment["deinit_log"] == "verbose" {
            shouldLogTextAnalyzer = true
        }
        if shouldLogTextAnalyzer { print("Deinit ThemesViewController") }
    }
    
    // MARK: - Actions
    @objc func classicThemeAction() {
        palette = clousure?(.classic)
//        palette = delegate?.changeThemeWorkDelegate(theme: .classic)
        view.backgroundColor = palette?.bubbleRightColor
        setBorderColorForButtons()
    }
    
    @objc func dayThemeAction() {
        palette = clousure?(.day)
//        palette = delegate?.changeThemeWorkDelegate(theme: .day)
        view.backgroundColor = palette?.bubbleRightColor
        setBorderColorForButtons()
    }
    
    @objc func nightThemeAction() {
        palette = clousure?(.night)
//        palette = delegate?.changeThemeWorkDelegate(theme: .night)
        view.backgroundColor = palette?.bubbleRightColor
        setBorderColorForButtons()
    }
    
}

// MARK: - Set Subviews
extension ThemesViewController {
   
    private func setSubviews() {
        setClassicView()
        let classicLabel = UILabel()
        classicLabel.font = .systemFont(ofSize: 25)
        classicLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(classicLabel)
        classicLabel.topAnchor.constraint(equalTo: classicView.bottomAnchor, constant: 15).isActive = true
        classicLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setDayView()
        setNightView()
        setBorderColorForButtons()
    }
    
    func setClassicView() {
        classicView.containerView.backgroundColor = .lightGray
        classicView.textLabel.text = "Classic"
        classicView.containerView.layer.cornerRadius = 20
        classicView.rightBubble.backgroundColor = colors.classicRightBubbleColor
        classicView.leftBubble.backgroundColor = colors.classicLeftBubbleColor
        classicView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(classicView)
        
        classicView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        classicView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        classicView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37).isActive = true
        classicView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -37).isActive = true
    }
    
    func setDayView() {
        dayView.containerView.backgroundColor = .gray
        dayView.textLabel.text = "Day"
        dayView.containerView.layer.cornerRadius = 20
        dayView.rightBubble.backgroundColor = colors.dayRightBubbleColor
        dayView.leftBubble.backgroundColor = colors.dayLeftBubbleColor
        dayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dayView)
        
        dayView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        dayView.topAnchor.constraint(equalTo: classicView.bottomAnchor, constant: 50).isActive = true
        dayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37).isActive = true
        dayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -37).isActive = true
    }
    
    func setNightView() {
        nightView.containerView.backgroundColor = .black
        nightView.textLabel.text = "Night"
        nightView.containerView.layer.cornerRadius = 20
        nightView.rightBubble.backgroundColor = colors.nightRightBubbleColor
        nightView.leftBubble.backgroundColor = colors.nightLeftBubbleColor
        nightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nightView)
        
        nightView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nightView.topAnchor.constraint(equalTo: dayView.bottomAnchor, constant: 50).isActive = true
        nightView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37).isActive = true
        nightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -37).isActive = true
    }
    
    private func setBorderColorForButtons() {
        classicView.containerView.layer.borderColor = palette?.borderColorForClassic.cgColor
        dayView.containerView.layer.borderColor = palette?.borderColorForDay.cgColor
        nightView.containerView.layer.borderColor = palette?.borderColorForNight.cgColor
    }
}

// MARK: - NavigationItem setting
extension ThemesViewController {
    
    private func setCancelButton() {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc func cancelAction() {
        guard let theme = lastTheme as? Theme else { return }
        palette = clousure?(theme)
//        palette = delegate?.changeThemeWorkDelegate(theme: theme)
        navigationController?.popViewController(animated: true)
    }
}
