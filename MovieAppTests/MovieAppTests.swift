//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Mariam Busayo Abdulkareem on 06/12/2021.
//

import XCTest

class MovieAppTests: XCTestCase {

    var sut: URLSession!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testApiValidity() throws {
//        given
        let urlString = "https://www.omdbapi.com/?S=batman&apikey=b8acaf2f"
    }
}
