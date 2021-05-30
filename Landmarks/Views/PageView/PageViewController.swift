//
//  PageViewController.swift
//  Landmarks
//
//  Created by Yingqiu Lee on 5/30/21.
//

import SwiftUI
import UIKit


// UIViewControllerRepresentable is used to create and manage UIViewController objects
// A UIViewController manages a view hierarchy for your UIKit App
/* Main responsibilities
    - Update the contents of the views, usually in response to changes to underlying data
    - Responding to user interactions with views
    - Resizing views and managing the layout of the overall interfact
    - Coordinating with other objects, including other view controllers, in the app
 
 UIViewcontrollers are UIResponder objects
 https://developer.apple.com/documentation/uikit/uiviewcontroller
 */

// This PageViewController uses a UIPageViewController to show content from a SwiftUI View
struct PageViewController<Page: View>: UIViewControllerRepresentable {

    //pages used to scroll between landmarks
    var pages: [Page]
    
    @Binding var currentPage: Int
    
    // SwiftUI will call this method before `makeUIViewController`, so you will
    // have access to the coordinator object when configuring the view controller
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //creates the view controller object and configures initial state
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    //updates the state of the specified view controller with new information from SwiftUI
    // context contains information about the current state of the system
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true
        )
    }
    
    //SwiftUI manages your UIViewControllerRepresentable type’s coordinator,
    //and provides it as part of the context when calling the methods you created above.
    //UIPageViewControllerDelegate methods allow the delegate to receive a notification when the
    // device orientation chagnes and when a user navigates to a new page.
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var parent: PageViewController
        
        //coordinator is a good place to store these controllers because the system initializes
        // them only once, and before you need them to update the view controller
        var controllers = [UIViewController]()
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }
        
        // need to implement to conform to UIPageViewControllerDataSource
        // establishes relationship between view controllers so that you can swipe back and forth between them
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            
            if index == 0 {
                return controllers.last
            }
            
            return controllers[index - 1]
        }
        
        // need to implement to conform to UIPageViewControllerDataSource
        // establishes relationship between view controllers so that you can swipe back and forth between them
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        //method conforms to UIPageViewControllerDelegate
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
        
    }
}
