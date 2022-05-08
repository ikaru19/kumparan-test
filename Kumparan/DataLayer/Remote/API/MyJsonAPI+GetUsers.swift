//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetUsersDataSource {
    func getUsersDataSource() -> Single<[Data.UserEntity]> {
        let endpoint = "users"

        return Single.create(subscribe: { [weak self] observer in
            self?.jsonRequestService.get(to: endpoint, param: [:], header: [:])
                    .subscribe(
                            onNext: { [weak self] data in
                                var usersData : [Data.UserEntity] = []
                                if let dict = data as? [[String: Any]] {
                                    for data in dict {
                                        if let processedData = self?.userDataMapper(dictionary: data) {
                                            usersData.append(processedData)
                                        }
                                    }
                                }
                                observer(.success(usersData))
                            },
                            onError: { [weak self] error in
                                observer(.error(error))
                            }
                    )
            return Disposables.create()
        })
    }
}

extension MyJsonAPI {
    func userDataMapper(dictionary: [String:Any]) -> Data.UserEntity? {
        guard let company = dictionary["company"] as? [String: Any],
              let address = dictionary["address"] as? [String: Any] else {
            return nil
        }
        var data = Data.UserEntity(
                id: dictionary["id"] as? Int,
                name: dictionary["name"] as? String,
                username: dictionary["username"] as? String,
                email: dictionary["email"] as? String,
                phone: dictionary["phone"] as? String,
                website: dictionary["website"] as? String,
                company: Data.Company(
                        name: company["name"] as? String,
                        catchPhrase: company["catchPhrase"] as? String,
                        bs: company["bs"] as? String
                ),
                address: Data.Address(
                        street: address["street"] as? String,
                        suite: address["suite"] as? String,
                        city: address["city"] as? String,
                        zipCode: address["zipCode"] as? String
                )
        )
        return data
    }
}
