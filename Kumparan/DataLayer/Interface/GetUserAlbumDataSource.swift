//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire

protocol GetUserAlbumDataSource: AnyObject {
    func getAlbum(userId: Int) -> Single<[Data.AlbumEntity]>
}