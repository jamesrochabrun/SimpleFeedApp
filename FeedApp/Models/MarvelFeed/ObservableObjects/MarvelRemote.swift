//
//  MarvelRemote.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import Foundation
import MarvelClient

// MARK:- Artwork
extension ComicViewModel: Artwork {
    public var imageURL: String { artwork.imagePathFor(variant: .squareStandardLarge) }
    public var thumbnailURL: String { artwork.imagePathFor(variant: .squareStandardSmall) }
}

extension CharacterViewModel: Artwork {
    
    public var imageURL: String { artwork?.imagePathFor(variant: .squareStandardLarge) ?? "" }
    public var thumbnailURL: String { artwork?.imagePathFor(variant: .squareStandardSmall) ?? "" }
}

extension SerieViewModel: Artwork {
    
    public var imageURL: String { artwork.imagePathFor(variant: .squareStandardFantastic) }
    public var thumbnailURL: String { artwork.imagePathFor(variant: .squareStandardSmall) }
}

final class MarvelRemote: ObservableObject {

    private let service = MarvelService(privateKey: "6905a8e2fb2033fdb10eea66645116669f1c4f04", publicKey: "27d25dbafd3ff80a9d448a19c11ace4d")
    
    @Published var comicViewModels: [ComicViewModel] = []
    @Published var characterViewModels: [CharacterViewModel] = []
    @Published var serieViewModels: [SerieViewModel] = []
    
    func fetchComics() {
        service.fetch(MarvelData<Resources<Comic>>.self) { [weak self] in
            switch $0 {
            case let .success(results):
                self?.comicViewModels = results.map { ComicViewModel(model: $0) }
            case let .failure(error):
                print("MarvelRemote fetching Comics error response \(error)")
            }
        }
    }
    
    func fetchCharacters() {
        service.fetch(MarvelData<Resources<Character>>.self, offset: 2, limit: 100) { [weak self]  in
            switch $0 {
            case let .success(results):
                self?.characterViewModels = results.map { CharacterViewModel(model: $0) }
            case let .failure(error):
                print("MarvelRemote fetching Characters error response \(error)")
            }
        }
    }
    
    func fetchSeries() {
        service.fetch(MarvelData<Resources<Serie>>.self, offset: 2, limit: 100) { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case let .success(results):
                self.serieViewModels = results.map { SerieViewModel(model: $0) }
            case let .failure(error):
                print("MarvelRemote fetching Series error response \(error)")
            }
        }
    }
}
