//
// Created by Engineering on 08/05/22.
//

import Foundation
import RxSwift
import Alamofire

protocol GetPhotoDataSource: AnyObject {
    func getPhotos(albumId: Int) -> Single<[Data.PhotoEntity]>
}