//
//  MainTableView.swift
//  PoketContact
//
//  Created by t2023-m0072 on 12/11/24.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // 사진 안짤리게 해주는거
        return imageView
    }()
    
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.clipsToBounds = true
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var profileNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileNameStackView, phoneNumberLabel])
        stackView.spacing = 20
        stackView.axis = .horizontal
        
        
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        configureStackViews()
        configureConstraints()
    }
    
    
    // 필수 구현
    required init?(coder: NSCoder) {
        fatalError("i0nit(coder:) has not been implemented")
    }
    
    private func configureStackViews() {
        self.contentView.addSubview(cellStackView)
    }
    
    private func configureConstraints() {
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //NSlayout으로 오토레이아웃 설정해주기 스택뷰들
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            
            cellStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            cellStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            cellStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            cellStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureCellData(profileImage: String, name: String, phoneNumber: String) {
        self.profileImageView.image = profileImage.toUIImage()
        self.nameLabel.text = name
        self.phoneNumberLabel.text = phoneNumber
    }
}


//URL Session에서 이미지에 대한 URL을 일단 스트링으로 받아 온후 후에 다시 데이터로 변경후 URL로 다시 변경할 예정
extension String {
    func toUIImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self) else { return nil }
        return UIImage(data: imageData)
    }
}
