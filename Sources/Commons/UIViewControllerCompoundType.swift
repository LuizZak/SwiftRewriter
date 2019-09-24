import SwiftAST

public enum UIViewControllerCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "UIViewController")
    
    public static func create() -> CompoundedMappingType {
        singleton
    }
    
    private static func typeString() -> String {
        let type = """
            class UIViewController: UIResponder, NSCoding, UIAppearanceContainer, UITraitEnvironment, UIContentContainer, UIFocusEnvironment {
                var view: UIView
                
                init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
                func viewDidLoad()
                func viewWillAppear(_ animated: Bool)
                func viewDidAppear(_ animated: Bool)
                func viewWillDisappear(_ animated: Bool)
                func viewDidDisappear(_ animated: Bool)
                func viewWillLayoutSubviews()
                func viewDidLayoutSubviews()
            }
            """
        
        return type
    }
}
