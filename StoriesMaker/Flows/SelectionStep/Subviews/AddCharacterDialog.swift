//
//  AddCharacterDialog.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 18/09/2024.
//

import UIKit
import Combine

class AddCharacterDialog: UIView {
    
    private enum GenderButtonState {
        case selected
        case deselected
        
        var titleColor: UIColor {
            switch self {
            case .selected:
                return Asset.Colors._262845.color
            case .deselected:
                return Asset.Colors.e7Ea73.color
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .selected:
                return Asset.Colors.e7Ea73.color
            case .deselected:
                return .clear
            }
        }
        
        var hasShadowedBorder: Bool {
            switch self {
            case .selected:
                return false
            case .deselected:
                return true
            }
        }
    }

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var enterNameLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var selectGenderLabel: UILabel!
    @IBOutlet private weak var girlButton: UIButton!
    @IBOutlet private weak var boyButton: UIButton!
    @IBOutlet private weak var genderDisclaimerLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    private static var nibName: String {
        String(describing: Self.self)
    }
    
    private var selectedGender: Gender = .female {
        didSet {
            guard oldValue != self.selectedGender else { return }
            self.refreshGenderButtons()
        }
    }
    
    private var saveButtonIsEnabledSubscription: AnyCancellable?
    
    var onSave: ((CustomCharacter) -> Void)?
    var onClose: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onClose?()
    }
    
    @IBAction func girlButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.selectedGender = .female
    }
    
    @IBAction func boyButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.selectedGender = .male
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        guard let text = self.nameTextField.text else { return }
        let character = CustomCharacter(name: text, gender: self.selectedGender)
        self.onSave?(character)
    }
    
    @IBAction func nameTextFieldEditingChanged(_ sender: UITextField) {
        self.saveButton.isEnabled = sender.text != nil && sender.text?.trimmingCharacters(in: [" "]) != ""
    }
}

// MARK: - Private
private extension AddCharacterDialog {
    
    func commonInit() {
        Bundle.main.loadNibNamed(Self.nibName, owner: self)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.setupUI()
    }
    
    func setupUI() {
        self.contentView.layer.cornerRadius = 18
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = Asset.Colors.fdffc2.color.cgColor
        self.contentView.layer.shadowRadius = 9
        self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.shadowColor = Asset.Colors.fdffc2.color.cgColor
        self.contentView.layer.shadowOffset = .zero
        
        self.setupNameTextField()
        self.setupGenderButtons()
        self.setupTexts()
        
        self.saveButton.isEnabled = false
        self.saveButton.layer.cornerRadius = 25
        self.saveButtonIsEnabledSubscription = self.saveButton.publisher(for: \.isEnabled)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.saveButton.alpha = isEnabled ? 1 : 0.5
            }
    }
    
    func setupNameTextField() {
        self.nameTextField.layer.cornerRadius = 25
        self.nameTextField.layer.borderWidth = 1
        self.nameTextField.layer.borderColor = Asset.Colors.fdffc2.color.cgColor
        self.nameTextField.layer.shadowRadius = 9
        self.nameTextField.layer.shadowOpacity = 1
        self.nameTextField.layer.shadowColor = Asset.Colors.fdffc2.color.cgColor
        self.nameTextField.layer.shadowOffset = .zero
        self.nameTextField.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        self.nameTextField.leftView = paddingView
        self.nameTextField.leftViewMode = .always
        self.nameTextField.tintColor = Asset.Colors.fdffc2.color
    }
    
    func setupGenderButtons() {
        let buttons: [UIButton] = [
            self.girlButton,
            self.boyButton
        ]
        buttons.forEach {
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = Asset.Colors.fdffc2.color.cgColor
            $0.layer.shadowColor = Asset.Colors.fdffc2.color.cgColor
            $0.layer.shadowOffset = .zero
        }
        self.setupGenderButton(self.girlButton, with: .selected)
        self.setupGenderButton(self.boyButton, with: .deselected)
    }
    
    private func setupGenderButton(
        _ button: UIButton,
        with state: GenderButtonState
    ) {
        button.setTitleColor(state.titleColor, for: .normal)
        button.backgroundColor = state.backgroundColor
        button.layer.borderWidth = state.hasShadowedBorder ? 1 : 0
        button.layer.shadowRadius = state.hasShadowedBorder ? 9 : 0
        button.layer.shadowOpacity = state.hasShadowedBorder ? 1 : 0
    }
    
    func refreshGenderButtons() {
        switch self.selectedGender {
        case .male:
            self.setupGenderButton(self.girlButton, with: .deselected)
            self.setupGenderButton(self.boyButton, with: .selected)
        case .female:
            self.setupGenderButton(self.girlButton, with: .selected)
            self.setupGenderButton(self.boyButton, with: .deselected)
        }
    }
    
    func setupTexts() {
        self.enterNameLabel.text = L10n.AddCharacter.enterName
        self.selectGenderLabel.text = L10n.AddCharacter.selectGender
        self.genderDisclaimerLabel?.text = L10n.AddCharacter.genderDisclaimer
        self.girlButton.setTitle(
            L10n.AddCharacter.girl,
            for: .normal
        )
        self.boyButton.setTitle(
            L10n.AddCharacter.boy,
            for: .normal
        )
        self.saveButton.setTitle(
            L10n.AddCharacter.save,
            for: .normal
        )
    }
}

extension AddCharacterDialog: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 35
    }
}
