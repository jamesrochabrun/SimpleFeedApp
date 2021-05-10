//
//  MockAPIClient.swift
//  FeedAppTests
//
//  Created by James Rochabrun on 5/5/21.
//

import Foundation
@testable import FeedApp
@testable import MarvelClient

class MockAPIClient {
    
    var shouldReturnError = false
    var requestWasCalled = false
    
    func reset() {
        shouldReturnError = false
        requestWasCalled = false
    }
    
    enum MockServiceError: Error {
        case failure
    }
    
    init(_ shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    convenience init() {
        self.init(false)
    }
    
//    var jsonResponse: String {
//        """
//        {"feed":{"title":"Coming Soon","id":"https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/10/explicit.json?at=1001l5Uo","author":{"name":"iTunes Store","uri":"http://wwww.apple.com/us/itunes/"},"links":[{"self":"https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/10/explicit.json?at=1001l5Uo"},{"alternate":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewRoom?fcId=1396220241\u0026app=music"}],"copyright":"Copyright © 2018 Apple Inc. 保留一切權利。","country":"us","icon":"http://itunes.apple.com/favicon.ico","updated":"2021-04-12T01:55:05.000-07:00","results":[{"artistName":"twenty one pilots","id":"1561836997","releaseDate":"2021-04-07","name":"Scaled And Icy","kind":"album","copyright":"℗ 2021 Fueled By Ramen LLC","artistId":"349736311","artistUrl":"https://music.apple.com/us/artist/twenty-one-pilots/349736311?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/64/82/1d/64821d19-14b2-7f58-8106-bccb4d04ada3/075679786210.jpg/200x200bb.png","genres":[{"genreId":"20","name":"Alternative","url":"https://itunes.apple.com/us/genre/id20"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"}],"url":"https://music.apple.com/us/album/scaled-and-icy/1561836997?app=music\u0026at=1001l5Uo"},{"artistName":"Olivia Rodrigo","id":"1560735414","releaseDate":"2021-05-21","name":"*O*R","kind":"album","copyright":"℗ 2021 Olivia Rodrigo, under exclusive license to Geffen Records","artistId":"979458609","contentAdvisoryRating":"Explicit","artistUrl":"https://music.apple.com/us/artist/olivia-rodrigo/979458609?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/91/0e/58/910e58d7-5853-3ca5-1b18-c9244899d363/21UMGIM26092.rgb.jpg/200x200bb.png","genres":[{"genreId":"14","name":"Pop","url":"https://itunes.apple.com/us/genre/id14"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"}],"url":"https://music.apple.com/us/album/o-r/1560735414?app=music\u0026at=1001l5Uo"},{"artistName":"GOJIRA","id":"1553446829","releaseDate":"2021-04-30","name":"Fortitude","kind":"album","copyright":"℗ 2021 Roadrunner Records Inc.","artistId":"65158676","artistUrl":"https://music.apple.com/us/artist/gojira/65158676?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/46/1c/75/461c75d9-0da8-7839-b347-81477d2e4258/075679796769.jpg/200x200bb.png","genres":[{"genreId":"1153","name":"Metal","url":"https://itunes.apple.com/us/genre/id1153"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"},{"genreId":"21","name":"Rock","url":"https://itunes.apple.com/us/genre/id21"}],"url":"https://music.apple.com/us/album/fortitude/1553446829?app=music\u0026at=1001l5Uo"},{"artistName":"St. Vincent","id":"1552955481","releaseDate":"2021-05-14","name":"Daddy's Home","kind":"album","copyright":"℗ 2021 Loma Vista Recordings., Distributed by Concord.","artistId":"198271209","artistUrl":"https://music.apple.com/us/artist/st-vincent/198271209?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/d4/75/e4/d475e41d-16b4-63f3-984f-0bf7615c6ed5/20CRGIM25029.rgb.jpg/200x200bb.png","genres":[{"genreId":"20","name":"Alternative","url":"https://itunes.apple.com/us/genre/id20"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"}],"url":"https://music.apple.com/us/album/daddys-home/1552955481?app=music\u0026at=1001l5Uo"},{"artistName":"Eric Church","id":"1547677185","releaseDate":"2021-04-16","name":"Heart","kind":"album","copyright":"An EMI Records Nashville Release; ℗ 2021 BigEC Records LLC, under exclusive license to UMG Recordings, Inc.","artistId":"123055194","artistUrl":"https://music.apple.com/us/artist/eric-church/123055194?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/5b/22/ea/5b22eaec-5b90-b785-7999-4389b1f9c6a5/20UMGIM88318.rgb.jpg/200x200bb.png","genres":[{"genreId":"6","name":"Country","url":"https://itunes.apple.com/us/genre/id6"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"}],"url":"https://music.apple.com/us/album/heart/1547677185?app=music\u0026at=1001l5Uo"},{"artistName":"Eric Church","id":"1547677830","releaseDate":"2021-04-23","name":"Soul","kind":"album","copyright":"An EMI Records Nashville Release; ℗ 2021 BigEC Records LLC, under exclusive license to UMG Recordings, Inc.","artistId":"123055194","artistUrl":"https://music.apple.com/us/artist/eric-church/123055194?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/9a/24/37/9a2437f3-40c3-4c5b-211c-8a1ddadebc77/20UMGIM88341.rgb.jpg/200x200bb.png","genres":[{"genreId":"6","name":"Country","url":"https://itunes.apple.com/us/genre/id6"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"}],"url":"https://music.apple.com/us/album/soul/1547677830?app=music\u0026at=1001l5Uo"},{"artistName":"Zoe Wees","id":"1561820793","releaseDate":"2021-05-21","name":"Golden Wings (Apple Music Up Next Film Edition) - EP","kind":"album","copyright":"A Capitol Records Release; ℗ 2021 Valeria Music, under exclusive license to Universal Music Operations Limited","artistId":"1470589518","artistUrl":"https://music.apple.com/us/artist/zoe-wees/1470589518?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/ad/79/ad/ad79ad93-47d8-a13a-a286-5d2edef64ce1/21UMGIM26548.rgb.jpg/200x200bb.png","genres":[{"genreId":"14","name":"Pop","url":"https://itunes.apple.com/us/genre/id14"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"}],"url":"https://music.apple.com/us/album/golden-wings-apple-music-up-next-film-edition-ep/1561820793?app=music\u0026at=1001l5Uo"},{"artistName":"Prince","id":"1561643530","releaseDate":"2021-07-30","name":"Welcome 2 America","kind":"album","copyright":"℗ 2021 NPG Records, Inc. under exclusive license to Legacy Recordings","artistId":"155814","artistUrl":"https://music.apple.com/us/artist/prince/155814?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is4-ssl.mzstatic.com/image/thumb/Music114/v4/55/46/19/55461993-6fd7-d703-9b39-03043f585203/886449187249.jpg/200x200bb.png","genres":[{"genreId":"15","name":"R\u0026B/Soul","url":"https://itunes.apple.com/us/genre/id15"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"}],"url":"https://music.apple.com/us/album/welcome-2-america/1561643530?app=music\u0026at=1001l5Uo"},{"artistName":"Sech","id":"1558956285","releaseDate":"2021-04-15","name":"42","kind":"album","copyright":"℗ 2021 Rich Music Inc","artistId":"579050972","contentAdvisoryRating":"Explicit","artistUrl":"https://music.apple.com/us/artist/sech/579050972?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is2-ssl.mzstatic.com/image/thumb/Music114/v4/e2/07/96/e2079680-1734-602d-e5b4-408139e58c90/192641697401_Cover.jpg/200x200bb.png","genres":[{"genreId":"1119","name":"Urbano latino","url":"https://itunes.apple.com/us/genre/id1119"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"},{"genreId":"12","name":"Latin","url":"https://itunes.apple.com/us/genre/id12"}],"url":"https://music.apple.com/us/album/42/1558956285?app=music\u0026at=1001l5Uo"},{"artistName":"Paul McCartney","id":"1557554388","releaseDate":"2021-04-16","name":"McCartney III Imagined","kind":"album","copyright":"Capitol Records; ℗ 2021 MPL Communications Ltd, under exclusive license to UMG Recordings, Inc.","artistId":"12224","artistUrl":"https://music.apple.com/us/artist/paul-mccartney/12224?app=music\u0026at=1001l5Uo","artworkUrl100":"https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/5b/95/58/5b9558f8-596b-44ca-5bfb-36ed16e10c8a/21UMGIM07001.rgb.jpg/200x200bb.png","genres":[{"genreId":"21","name":"Rock","url":"https://itunes.apple.com/us/genre/id21"},{"genreId":"34","name":"Music","url":"https://itunes.apple.com/us/genre/id34"}],"url":"https://music.apple.com/us/album/mccartney-iii-imagined/1557554388?app=music\u0026at=1001l5Uo"}]}}
//        """
//    }
}

extension MockAPIClient: GenericAPI {
    var session: URLSession { URLSession(configuration: .default) }
    
    /// Error needs to be the one in the GenericAPI
    private func fetch<T>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
        if shouldReturnError {
          //  completion(.failure(APIError.jsonConversionFailure(description: "")))
        } else {
            // 1 convert the `jsonResponse` string to json
            /// 2 convert the json in to a decodable object
           // 3 completion(.success(model))
        }
    }
}
