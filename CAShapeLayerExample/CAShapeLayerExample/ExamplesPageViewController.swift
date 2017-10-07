import UIKit


class ExamplesPageViewController: UIPageViewController {
    
    var children: [ UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.children = [
            UIStoryboard(name: "Shapes", bundle: nil).instantiateViewController(withIdentifier: "ChainedAnimationsShapeViewController"),
            UIStoryboard(name: "Shapes", bundle: nil).instantiateViewController(withIdentifier: "ExperimentalSlideViewController")
            // exclude this as UIPageViewController seems to hijack the GestureRecognizer
            // run this as its own initial view contorll
            // UIStoryboard(name: "Shapes", bundle: nil).instantiateViewController(withIdentifier: "SwipedAnimationsViewController")
        ]
        self.dataSource = self
        
        if let vc = self.children.first {
            self.setViewControllers( [ vc], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
    }
}

extension ExamplesPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.children.index( of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return children.last
        }
        
        guard children.count > previousIndex else {
            return nil
        }
        
        let vc = children[ previousIndex]
        vc.title = vc.description
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = children.index( of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = children.count
        
        // On the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return children.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        let vc = children[ nextIndex]
        vc.title = vc.description
        return vc
    }
    
}
