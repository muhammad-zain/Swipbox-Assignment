//
//  MovieDetailService.swift
//  SwipBoxTests
//
//  Created by Zain Sidhu on 03/09/2023.
//

import XCTest
@testable import SwipBox

struct SuccessMokeDataManager: NetworkManagerProtocol {
    func getRequest(with url: URL, headers: [String : String], completion: @escaping (Result<Data, Error>) -> Void) {
        
        let mockData: Movie = Movie(id: 1, title: "Mock Title", tagline: "Mock tagline", overview: "Mock overview", releaseDate: "2023-04-20", rating: 5.0, posterPath: "", backdropPath: "")
        
        do {
            let data = try JSONEncoder().encode(mockData)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
        
    }
}

struct InvalidDataMokeDataManager: NetworkManagerProtocol {
    func getRequest(with url: URL, headers: [String : String], completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.success(Data()))
    }
}

final class MovieDetailServiceTests: XCTestCase {
    
    func testFetchMovieDetail_Success() {
        let movieDetailService = MovieDetailService(networkManager: SuccessMokeDataManager())
        let expectation = XCTestExpectation(description: "Fetch movie detail data successfully")
        movieDetailService.fetchMovieDetail(movieId: 1) { result in
            switch result {
            case .success(let movie):
                XCTAssertEqual(movie.id, 1)
                XCTAssertEqual(movie.title, "Mock Title")
                XCTAssertEqual(movie.tagline, "Mock tagline")
                XCTAssertEqual(movie.overview, "Mock overview")
                XCTAssertEqual(movie.rating, 5.0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchMovieDetail_InvalidData() {
        let movieDetailService = MovieDetailService(networkManager: InvalidDataMokeDataManager())
        let expectation = XCTestExpectation(description: "Fetch movie detail data with invalid Data")
        movieDetailService.fetchMovieDetail(movieId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to invalid Data, but received success")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidData)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
