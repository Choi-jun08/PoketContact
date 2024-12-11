//
//  AddMemberViewController.swift
//  PoketContact
//
//  Created by t2023-m0072 on 12/11/24.
//

import UIKit
import CoreData

final class AddMemberViewController: UIViewController {
    private let addMemberView: AddMemberView?
    private var oldName: String?
    private let pokeDataManager = PokeDataManager()
    
    init() {
        self.addMemberView = AddMemberView()
        super.init(nibName: nil, bundle: nil)
        self.configureNavigationBar(title: "연락처 추가")
        
    }
    
    init(profileImage: String, name: String, phoneNumber: String) {
        self.oldName = name
        self.addMemberView = AddMemberView(profileImage: profileImage, name: name, phoneNumber: phoneNumber)
        super.init(nibName: nil, bundle: nil)
        self.configureNavigationBar(title: name)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addMemberView
        addMemberView?.delegate = self
        configurePokeProfile()
    }
    
    private func configureNavigationBar(title: String) {
        self.view.backgroundColor = .white
        self.navigationItem.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(completeButtonTapped))
    }
    private func configurePokeProfile() {
        pokeDataManager.fetchRandomPokemon { result in
            
            if let image = result{
                DispatchQueue.main.async { [weak self] in
                    self?.addMemberView?.configureProfileImage(image: image)
                }
            }else{ print("Error")}
        }
        
    }
    @objc private func completeButtonTapped() {
        let image = addMemberView?.profileImageView.image?.toString() ?? ""
        let name = addMemberView?.nameTextField.text ?? ""
        let phoneNumber = addMemberView?.phoneNumberTextField.text ?? ""
        
        if let oldName = self.oldName {
            pokeDataManager.updateMember(currentName: oldName, updateProfileImage: image, updateName: name, updatePhoneNumber: phoneNumber)
        } else {
            pokeDataManager.createData(name: name, phoneNumber: phoneNumber, image: image)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension AddMemberViewController: RandomImageButtonDelegate {
    func changeRandomImage() {
        self.configurePokeProfile()
    }
}

extension UIImage {
    func toString() -> String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}
