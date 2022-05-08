//
// Created by Engineering on 08/05/22.
//

import Foundation
import RxSwift

protocol PhotosViewModelDelegate: AnyObject {
    func onFinishFetch()
}

protocol PhotosViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var photos: Observable<[Domain.PhotoEntity]> { get }
    var delegate: PhotosViewModelDelegate? { get set }

    func refreshPage(albumId: Int)
    func getPhotos(albumId: Int)
}