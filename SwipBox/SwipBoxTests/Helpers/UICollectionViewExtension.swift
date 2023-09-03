//
//  UICollectionViewExtension.swift
//  SwipBoxTests
//
//  Created by Zain Sidhu on 03/09/2023.
//

import XCTest
@testable import SwipBox

class UICollectionViewExtension: XCTestCase {

    var collectionView: UICollectionView!

    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
    }

    override func tearDown() {
        collectionView = nil
        super.tearDown()
    }

    func testShowMessageLabel() {
        let message = "No data available"
        
        collectionView.showMessageLabel(with: message)
        
        let label = collectionView.viewWithTag(collectionView.emptyMessageLabelTag) as? UILabel
        XCTAssertNotNil(label, "Empty message label should be added to the collcetion view")
        XCTAssertEqual(label?.text, message, "Empty message label text should match the provided message")
        XCTAssertEqual(label?.textAlignment, .center, "Empty message label alignment should be centered")
    }

    func testHideEmptyMessageLabel() {
        collectionView.hideEmptyMessageLabel()
        
        let label = collectionView.viewWithTag(collectionView.emptyMessageLabelTag) as? UILabel
        XCTAssertNil(label, "Empty message label should be removed from the collection view")
    }

    func testShowLoadingIndicator() {
        collectionView.showLoadingIndicator()
        
        let indicatorView = collectionView.viewWithTag(collectionView.loadingViewTag) as? UIActivityIndicatorView
        XCTAssertNotNil(indicatorView, "Loading indicator view should be added to the collection view")
        XCTAssertTrue(indicatorView?.isAnimating ?? false, "Loading indicator should be animating")
        XCTAssertFalse(collectionView.isUserInteractionEnabled, "Collection view user interaction should be disabled")
    }

    func testHideLoadingIndicator() {
        collectionView.hideLoadingIndicator()
        let indicatorView = collectionView.viewWithTag(collectionView.loadingViewTag) as? UIActivityIndicatorView
        XCTAssertNil(indicatorView, "Loading indicator view should be removed from the collection view")
        XCTAssertTrue(collectionView.isUserInteractionEnabled, "Coleection view user interaction should be enabled")
    }

}

