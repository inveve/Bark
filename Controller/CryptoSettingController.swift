//
//  CryptoSettingController.swift
//  Bark
//
//  Created by huangfeng on 2022/11/10.
//  Copyright © 2022 Fin. All rights reserved.
//

import UIKit
import RxSwift

class CryptoSettingController: BaseViewController<CryptoSettingModel> {
    let algorithmFeild = DropBoxView(values: ["AES128", "AES192", "AES256"])
    let modeFeild = DropBoxView(values: ["CBC", "ECB", "GCM"])
    let paddingField = DropBoxView(values: ["pkcs7"])
    
    let keyTextField: BorderTextField = {
        let textField = BorderTextField(title: "Key")
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = NSLocalizedString("enterKey")
        return textField
    }()

    let ivTextField: BorderTextField = {
        let textField = BorderTextField(title: "IV")
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = NSLocalizedString("enterIv")
        return textField
    }()

    let previewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = BKColor.grey.darken4
        label.text = "\(NSLocalizedString("preview")): \"helloworld\" -> \"DASGKJLSAJKGH==\""
        return label
    }()

    let doneButton: BKButton = {
        let btn = BKButton()
        btn.setTitle(NSLocalizedString("done"), for: .normal)
        btn.setTitleColor(BKColor.lightBlue.darken3, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.fontSize = 14
        return btn
    }()

    let copyButton: UIButton = {
        let btn = GradientButton()
        btn.setTitle(NSLocalizedString("copyExample"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.applyGradient(
            withColours: [
                UIColor(r255: 36, g255: 51, b255: 236),
                UIColor(r255: 70, g255: 44, b255: 233),
            ],
            gradientOrientation: .horizontal)
        return btn
    }()

    let scrollView = UIScrollView()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func makeUI() {
        self.title = NSLocalizedString("encryptionSettings")
        self.navigationItem.setRightBarButtonItem(item: UIBarButtonItem(customView: doneButton))

        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        func getTitleLabel(title: String) -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = BKColor.grey.darken4
            label.text = title
            return label
        }

        let algorithmLabel = getTitleLabel(title: NSLocalizedString("algorithm"))
        let modeLabel = getTitleLabel(title: NSLocalizedString("mode"))
        let paddingLabel = getTitleLabel(title: "Padding")
        let keyLabel = getTitleLabel(title: "Key")
        let ivLabel = getTitleLabel(title: "Iv")

        self.scrollView.addSubview(algorithmLabel)
        self.scrollView.addSubview(algorithmFeild)

        self.scrollView.addSubview(modeLabel)
        self.scrollView.addSubview(modeFeild)

        self.scrollView.addSubview(paddingLabel)
        self.scrollView.addSubview(paddingField)

        self.scrollView.addSubview(keyLabel)
        self.scrollView.addSubview(keyTextField)

        self.scrollView.addSubview(ivLabel)
        self.scrollView.addSubview(ivTextField)

        self.scrollView.addSubview(previewLabel)
        self.scrollView.addSubview(copyButton)

        self.view.backgroundColor = UIColor.white

        algorithmLabel.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.left.equalTo(24)
        }
        algorithmFeild.snp.makeConstraints { make in
            make.top.equalTo(algorithmLabel.snp.bottom).offset(5)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(45)
            make.width.equalToSuperview().offset(-40)
        }

        modeLabel.snp.makeConstraints { make in
            make.top.equalTo(algorithmFeild.snp.bottom).offset(20)
            make.left.equalTo(algorithmLabel)
        }
        modeFeild.snp.makeConstraints { make in
            make.left.right.height.equalTo(algorithmFeild)
            make.top.equalTo(modeLabel.snp.bottom).offset(5)
        }

        paddingLabel.snp.makeConstraints { make in
            make.top.equalTo(modeFeild.snp.bottom).offset(20)
            make.left.equalTo(algorithmLabel)
        }
        paddingField.snp.makeConstraints { make in
            make.left.right.height.equalTo(modeFeild)
            make.top.equalTo(paddingLabel.snp.bottom).offset(5)
        }

        keyLabel.snp.makeConstraints { make in
            make.top.equalTo(paddingField.snp.bottom).offset(20)
            make.left.equalTo(algorithmLabel)
        }
        keyTextField.snp.makeConstraints { make in
            make.left.right.height.equalTo(paddingField)
            make.top.equalTo(keyLabel.snp.bottom).offset(5)
        }

        ivLabel.snp.makeConstraints { make in
            make.top.equalTo(keyTextField.snp.bottom).offset(20)
            make.left.equalTo(algorithmLabel)
        }
        ivTextField.snp.makeConstraints { make in
            make.left.right.height.equalTo(keyTextField)
            make.top.equalTo(ivLabel.snp.bottom).offset(5)
        }

        previewLabel.snp.makeConstraints { make in
            make.left.equalTo(ivLabel)
            make.top.equalTo(ivTextField.snp.bottom).offset(20)
        }

        copyButton.snp.makeConstraints { make in
            make.left.equalTo(ivTextField)
            make.right.equalTo(ivTextField)
            make.height.equalTo(42)
            make.top.equalTo(previewLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resign)))
    }

    @objc func resign() {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BKColor.white
    }
    
    override func bindViewModel() {
        
        let output = viewModel.transform(input: CryptoSettingModel.Input(
            algorithmChanged: self.algorithmFeild
                .rx
                .currentValueChanged
                .compactMap{$0}
                .asDriver(onErrorDriveWith: .empty())
        ))
        
        output.algorithmList
            .map{$0.map {$0.rawValue}}
            .drive(self.algorithmFeild.rx.values)
            .disposed(by: rx.disposeBag)
        
        output.modeList
            .drive(self.modeFeild.rx.values)
            .disposed(by: rx.disposeBag)
        
        output.paddingList
            .drive(self.paddingField.rx.values)
            .disposed(by: rx.disposeBag)
        
        output.keyLenght.drive(onNext: {[weak self] keyLenght in
            self?.keyTextField.placeholder = String(format: NSLocalizedString("enterKey"), keyLenght)
        }).disposed(by: rx.disposeBag)
    }
}