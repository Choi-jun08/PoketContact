//
//  PokeDataModel.swift
//  PoketContact
//
//  Created by t2023-m0072 on 12/11/24.
//

import Foundation
import UIKit
import CoreData


final class PokeDataManager {
    var pokemon: PokeResponse?
    private var container: NSPersistentContainer!
    
    func fetchRandomPokemon(completion: @escaping (UIImage?) -> Void) {
        let randomID = Int.random(in: 1...1000) // Pokedex ID 범위
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomID)"
        guard let url: URL = URL(string: urlString) else {
            print("URL is not correct")
            return
        }
        // URLRequest 설정
        var request: URLRequest = URLRequest(url: url)
        // GET 메소드 사용
        request.httpMethod = "GET"
        // json 데이터 형식임을 나타냄
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // URLSession 생성 (기본 default 세션)
        let session: URLSession = URLSession(configuration: .default)
        // dataTask
        session.dataTask(with: request) { (data, response, error) in
            // http 통신 response 에는 status code 가 함께오는데, 200번대가 성공을 의미.
            let successRange: Range = (200..<300)
            // 통신 성공
            guard let data, error == nil else { return }
            if let response: HTTPURLResponse = response as? HTTPURLResponse{
                print("status code: \(response.statusCode)")
                // 요청 성공 (StatusCode가 200번대)
                if successRange.contains(response.statusCode){
                    // decode
                    guard let userInfo: PokeResponse = try? JSONDecoder().decode(PokeResponse.self, from: data),
                          let Urlsprites = userInfo.sprites.frontDefault,
                          let urlSpritesImage = URL(string: Urlsprites),
                          let urlSpritesImageData = try? Data(contentsOf: urlSpritesImage),
                          let image = UIImage(data: urlSpritesImageData)
                    else { return }
                    completion(image)
                    
                    print(userInfo)
                } else { // 요청 실패 (Status code가 200대 아님)
                    print("요청 실패")
                }
            }
        }.resume()
    }
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
   
    func updateMember(currentName: String, updateProfileImage: String, updateName: String, updatePhoneNumber: String) {
            let fetchRequest = PokeContactBook.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", currentName)
            
            do {
                let result = try self.container.viewContext.fetch(fetchRequest)
                
                for data in result as [NSManagedObject] {
                    data.setValue(updateProfileImage, forKey: PokeContactBook.Key.profileImage)
                    data.setValue(updateName, forKey: PokeContactBook.Key.name)
                    data.setValue(updatePhoneNumber, forKey: PokeContactBook.Key.phoneNumber)
                    
                    try self.container.viewContext.save()
                    print("데이터 수정 완료")
                }
                
            } catch {
                print("데이터 수정 실패")
            }
        }
    
    
    
    
    func createData(name:String, phoneNumber: String, image: String?) {
        guard let entity = NSEntityDescription.entity(forEntityName: PokeContactBook.className, in: self.container.viewContext) else {
            return}
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPhoneBook.setValue(name, forKey: PokeContactBook.Key.name)
        newPhoneBook.setValue(phoneNumber, forKey: PokeContactBook.Key.phoneNumber)
        newPhoneBook.setValue(image, forKey: PokeContactBook.Key.profileImage)
        
        do {
            try self.container.viewContext.save()
            print("문맥 저장 성공")
        } catch {
            print("문맥 저장 실패")
        }
        
    }
    
}


struct PokeResponse: Decodable {
    let sprites: Sprites


    struct Sprites: Decodable {
        let frontDefault: String?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}


