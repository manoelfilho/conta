import UIKit
import Lottie

class OnBoardingController: UIPageViewController {

    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    let initialPage = 0
    
    private lazy var buttonFoward: UIButton = {
        let buttom: UIButton = .roundedSymbolButton(
            symbolName: "arrow.forward",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: .clear,
            size: .init(width: 60, height: 60),
            cornerRadius: 30
        )
        buttom.tintColor = .white
        return buttom
    }()
    
    private lazy var buttonBackward: UIButton = {
        let buttom: UIButton = .roundedSymbolButton(
            symbolName: "arrow.backward",
            pointSize: 30,
            weight: .light,
            scale: .default,
            color: .clear,
            size: .init(width: 60, height: 60),
            cornerRadius: 30
        )
        buttom.tintColor = .white
        return buttom
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
    }
}

extension OnBoardingController {
    
    func setup() {
        
        dataSource = self
        delegate = self

        pages.append(ViewController1())
        pages.append(ViewController2())
        pages.append(ViewController3())
        
        buttonFoward.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        buttonBackward.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: false, completion: nil)
    }
    
    func style() {
        pageControl.isEnabled = false
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
    }
    
    func layout() {
        
        view.addSubview(pageControl)
        view.addSubview(buttonBackward)
        view.addSubview(buttonFoward)
        
        pageControl.fill(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 70, right: 0)
        )
        
        buttonBackward.fill(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil,
            padding: .init(top: 0, left:20, bottom: 70, right: 0)
        )
        
        buttonFoward.fill(
            top: nil,
            leading: nil,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 70, right: 20)
        )
        
    }
}

// MARK: - Actions
extension OnBoardingController {
    @objc func goForward(){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    @objc func goBack(){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        guard let beforeViewController = self.dataSource?.pageViewController( self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([beforeViewController], direction: .reverse, animated: true, completion: nil)
    }
}

// MARK: - DataSources
extension OnBoardingController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }
    }
}

// MARK: - Delegates
extension OnBoardingController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
    
}
