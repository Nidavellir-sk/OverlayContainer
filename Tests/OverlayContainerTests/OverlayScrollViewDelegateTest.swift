//
//  ScrollViewDelegateTest.swift
//  OverlayContainer_Tests
//
//  Created by Gaétan Zanella on 24/12/2018.
//  Copyright © 2018 Gaétan Zanella. All rights reserved.
//

import Nimble
import Quick
import UIKit
import OverlayContainer

private class ScrollViewController: UIViewController, UIScrollViewDelegate {
    var scrollView = UIScrollView()
}

class OverlayScrollViewDelegateTest: QuickSpec {
    override func spec() {
        var viewController: ScrollViewController!
        var overlayContainer: OverlayContainerViewController!

        beforeEach {
            viewController = ScrollViewController()
            overlayContainer = OverlayContainerViewController()
            overlayContainer.viewControllers = [viewController]
            overlayContainer.loadViewIfNeeded()
        }

        it("should observe the scroll view delegate") {
            overlayContainer.drivingScrollViews = [WeakOverlayScrollView(viewController.scrollView)]
            expect(viewController.scrollView.delegate).toNot(beNil())
            viewController.scrollView.delegate = viewController
            expect(viewController.scrollView.delegate).toNot(beIdenticalTo(viewController))
        }

        it("should restore the scroll view delegate") {
            viewController.scrollView.delegate = viewController
            expect(viewController.scrollView.delegate).to(beIdenticalTo(viewController))
            overlayContainer.drivingScrollViews = [WeakOverlayScrollView(viewController.scrollView)]
            expect(viewController.scrollView.delegate).toNot(beIdenticalTo(viewController))
            overlayContainer.drivingScrollViews = []
            expect(viewController.scrollView.delegate).to(beIdenticalTo(viewController))
        }

        it("should handle a delegate conflict between two overlay containers") {
            let secondaryContainer = OverlayContainerViewController()
            secondaryContainer.viewControllers = [viewController]
            secondaryContainer.loadViewIfNeeded()
            overlayContainer.drivingScrollViews = [WeakOverlayScrollView(viewController.scrollView)]
            secondaryContainer.drivingScrollViews = [WeakOverlayScrollView(viewController.scrollView)]
            viewController.scrollView.delegate = viewController
            expect(viewController.scrollView.delegate).toNot(beIdenticalTo(viewController))
        }

        it("should restore the scroll view delegate in case of a delegate conflict") {
            let secondaryContainer = OverlayContainerViewController()
            secondaryContainer.viewControllers = [viewController]
            secondaryContainer.loadViewIfNeeded()

            viewController.scrollView.delegate = viewController
            expect(viewController.scrollView.delegate).to(beIdenticalTo(viewController))

            overlayContainer.drivingScrollViews = [WeakOverlayScrollView(viewController.scrollView)]
            expect(viewController.scrollView.delegate).toNot(beIdenticalTo(viewController))

            secondaryContainer.drivingScrollViews = [WeakOverlayScrollView(viewController.scrollView)]
            expect(viewController.scrollView.delegate).toNot(beIdenticalTo(viewController))

            secondaryContainer.drivingScrollViews = []
            expect(viewController.scrollView.delegate).to(beIdenticalTo(viewController))
        }
    }
}
