//
//  DeliveryStatusCard.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 07.06.2022.
//

import Foundation
import UIKit
// TODO: Alesya Volosach | Доработать установку стилей текста в didSet

/**
View: Карточка для группы-статуса
 
Визуально включает в себя либо одну, либо 2 плашки с информацией о принятие/отдаче заказа
 */
class DeliveryStatusCardView: UIStackView {
    @IBOutlet private var contentView: UIStackView!
    
    @IBOutlet private weak var mainInfoContainer: UIStackView!
    // Only version before iOS 14
    private let mainInfoBackgroundView = UIView()
    
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var modeTitleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    // TODO: Alesya Volosach | Пересмотреть отображать кнопку или сделать невидимую кнопку захватывающую в область нажатия адрес
    
    @IBOutlet private weak var addressContainer: UIStackView!
    @IBOutlet private weak var openMapLabel: UILabel!
    private var transparentOpenMapButton: UIButton?
    @IBOutlet private weak var pickUpInfoLabel: UILabel!
    @IBOutlet private weak var changeButton: UIButton!
    @IBOutlet private weak var planneDeliveryInfoLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    @IBOutlet private weak var keepInfoContainer: UIView!
    @IBOutlet private weak var keepInfoLabel: UILabel!
    @IBOutlet private weak var keepInfoButton: UIButton!
    
    private var cardModel: DeliveryStatusViewModel.Card?
    
    enum Constant {
        // TODO: Alesya Volosach | было бы круто вынести куда-то к ui-lib эту константу, она распространяется на все виджеты и практически все плашки
        static let surfaceCornerRadius: CGFloat = 12
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        // TODO: Alesya Volosach | В проекте поменять логику встраивания subviews
        Bundle.main.loadNibNamed("DeliveryStatusCardView", owner: self, options: nil)
        self.addArrangedSubview(contentView)
        self.axis = .vertical
        
        // Reset titles
        keepInfoButton.setTitle("", for: .normal)
        
        // BackgroundView for mainContainer
        if #available(iOS 14, *) {
            mainInfoContainer.cornerRadius = Constant.surfaceCornerRadius
            mainInfoContainer.borderColor = UIColor(named: "borderSurface")
            mainInfoContainer.borderWidth = 1
        } else {
            mainInfoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            mainInfoContainer.insertSubview(mainInfoBackgroundView, at: 0)
            NSLayoutConstraint.activate([
                mainInfoBackgroundView.leadingAnchor.constraint(equalTo: mainInfoContainer.leadingAnchor),
                mainInfoBackgroundView.trailingAnchor.constraint(equalTo: mainInfoContainer.trailingAnchor),
                mainInfoBackgroundView.topAnchor.constraint(equalTo: mainInfoContainer.topAnchor),
                mainInfoBackgroundView.bottomAnchor.constraint(equalTo: mainInfoContainer.bottomAnchor)
            ])
            
            mainInfoBackgroundView.backgroundColor = .white
            mainInfoBackgroundView.cornerRadius = Constant.surfaceCornerRadius
            mainInfoBackgroundView.borderColor = UIColor(named: "borderSurface")
            mainInfoBackgroundView.borderWidth = 1
        }
        
        keepInfoContainer.cornerRadius = Constant.surfaceCornerRadius
        keepInfoContainer.borderColor = UIColor(named: "borderSurface")
        keepInfoContainer.borderWidth = 1
        
        // Buttons insets
        if #available(iOS 15, *) {
            changeButton.configuration?.contentInsets = .init(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
        } else {
            changeButton.imageEdgeInsets = .init(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0
            )
        }
        
        // Buttons fonts
        // TODO: Alesya Volosach | На 15 версии сбрасывается
        changeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    // MARK: - Actions Outlets

    @objc func tappedOpenMap(_ sender: Any) {
        print("| Log | Open map")
        // Открытие отсюда
    }
    
    @IBAction func tappedChange(_ sender: Any) {
        print("| Log | Tap change")
        // Output
    }
    
    @IBAction func tappedKeepInfo(_ sender: Any) {
        print("| Log | Open keep Info: Url: \(cardModel?.keepInfoLink)")
        // Открытие отсюда
    }
    
    // MARK: - Configure
    
    func configure(_ cardModel: DeliveryStatusViewModel.Card) {
        self.cardModel = cardModel
        
        iconView.image = cardModel.icon
        modeTitleLabel.text = cardModel.title
        addressLabel.text = cardModel.address
        
        if cardModel.officeId != nil {
            openMapLabel.isHidden = false
            configureTransparentOpenMapButton()
        } else {
            openMapLabel.isHidden = true
        }
        
        pickUpInfoLabel.isHidden = cardModel.pickUpInfo == nil
        pickUpInfoLabel.text = cardModel.pickUpInfo
        
        changeButton.isHidden = !cardModel.displayChangeButton
        
        planneDeliveryInfoLabel.isHidden = cardModel.planedDeliveryInfo == nil
        planneDeliveryInfoLabel.text = cardModel.planedDeliveryInfo
        
        messageLabel.isHidden = cardModel.message == nil
        messageLabel.text = cardModel.message
        
        keepInfoContainer.isHidden = cardModel.keepDateInfo == nil
        keepInfoLabel.text = cardModel.keepDateInfo
    }
    
    private func configureTransparentOpenMapButton() {
        let transparentOpenMapButton = UIButton()
        transparentOpenMapButton.backgroundColor = .clear
        transparentOpenMapButton.setTitle("", for: .normal)
        
        // Constraints
        transparentOpenMapButton.translatesAutoresizingMaskIntoConstraints = false
        
        addressContainer.insertSubview(transparentOpenMapButton, at: 0)
        
        NSLayoutConstraint.activate([
            transparentOpenMapButton.leadingAnchor.constraint(equalTo: addressContainer.leadingAnchor),
            transparentOpenMapButton.trailingAnchor.constraint(equalTo: addressContainer.trailingAnchor),
            transparentOpenMapButton.topAnchor.constraint(equalTo: addressLabel.topAnchor),
            transparentOpenMapButton.bottomAnchor.constraint(equalTo: openMapLabel.bottomAnchor)
        ])
        
        // Action
        transparentOpenMapButton.addTarget(self, action: #selector(tappedOpenMap), for: .touchDown)
        
        // Save
        self.transparentOpenMapButton = transparentOpenMapButton
    }
}
