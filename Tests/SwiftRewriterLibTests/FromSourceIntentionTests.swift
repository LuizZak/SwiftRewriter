import XCTest
import SwiftRewriterLib
import TestCommons

class FromSourceIntentionTests: XCTestCase {
    func testIsVisiblePublicSymbol() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createGlobalVariable(withName: "global", type: .int, accessLevel: .public)
                        .createClass(withName: "A") { builder in
                            builder.createConstructor()
                        }
                }
                .createFile(named: "B") { file in
                    file.createClass(withName: "B") { builder in
                        builder.createConstructor()
                    }
                }
                .build()
        let memberSameFile = intentions.fileIntentions()[0].classIntentions[0].constructors[0]
        let memberOtherFile = intentions.fileIntentions()[1].classIntentions[0].constructors[0]
        let sut = intentions.fileIntentions()[0].globalVariableIntentions[0]
        
        XCTAssertTrue(sut.isVisible(for: memberSameFile))
        XCTAssertTrue(sut.isVisible(for: memberOtherFile))
    }
    
    func testIsVisibleInternalSymbol() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createGlobalVariable(withName: "global", type: .int, accessLevel: .internal)
                        .createClass(withName: "A") { builder in
                            builder.createConstructor()
                        }
                }
                .createFile(named: "B") { file in
                    file.createClass(withName: "B") { builder in
                        builder.createConstructor()
                    }
                }
                .build()
        let memberSameFile = intentions.fileIntentions()[0].classIntentions[0].constructors[0]
        let memberOtherFile = intentions.fileIntentions()[1].classIntentions[0].constructors[0]
        let sut = intentions.fileIntentions()[0].globalVariableIntentions[0]
        
        XCTAssertTrue(sut.isVisible(for: memberSameFile))
        XCTAssertTrue(sut.isVisible(for: memberOtherFile))
    }
    
    func testIsVisibleFileprivateSymbol() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createGlobalVariable(withName: "global", type: .int, accessLevel: .fileprivate)
                        .createClass(withName: "A") { builder in
                            builder.createConstructor()
                        }
                }
                .createFile(named: "B") { file in
                    file.createClass(withName: "B") { builder in
                        builder.createConstructor()
                    }
                }
                .build()
        let memberSameFile = intentions.fileIntentions()[0].classIntentions[0].constructors[0]
        let memberOtherFile = intentions.fileIntentions()[1].classIntentions[0].constructors[0]
        let sut = intentions.fileIntentions()[0].globalVariableIntentions[0]
        
        XCTAssertTrue(sut.isVisible(for: memberSameFile))
        XCTAssertFalse(sut.isVisible(for: memberOtherFile))
    }
    
    func testIsVisiblePrivateGlobalVariableScopeSymbol() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createGlobalVariable(withName: "global", type: .int, accessLevel: .private)
                        .createClass(withName: "A") { builder in
                            builder.createConstructor()
                        }
                }
                .createFile(named: "B") { file in
                    file.createClass(withName: "B") { builder in
                        builder.createConstructor()
                    }
                }
                .build()
        let memberSameFile = intentions.fileIntentions()[0].classIntentions[0].constructors[0]
        let memberOtherFile = intentions.fileIntentions()[1].classIntentions[0].constructors[0]
        let sut = intentions.fileIntentions()[0].globalVariableIntentions[0]
        
        XCTAssertTrue(sut.isVisible(for: memberSameFile))
        XCTAssertFalse(sut.isVisible(for: memberOtherFile))
    }
    
    func testIsVisiblePrivateConstructorAtSameFile() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A") { builder in
                            builder.createConstructor { ctor in
                                ctor.setAccessLevel(.private)
                            }
                        }.createClass(withName: "B") { builder in
                            builder.createConstructor()
                        }
                }
                .build()
        let classA = intentions.fileIntentions()[0].classIntentions[0]
        let classB = intentions.fileIntentions()[0].classIntentions[1]
        let sut = classA.constructors[0]
        let ctorB = classB.constructors[0]
        
        XCTAssertTrue(sut.isVisible(for: classA))
        XCTAssertFalse(sut.isVisible(for: classB))
        XCTAssertFalse(sut.isVisible(for: ctorB))
    }
    
    func testPrivateMembersVisibleToExtensionsWithinSameFile() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A") { builder in
                            builder.createVoidMethod(named: "a") { method in
                                method.setAccessLevel(.private)
                            }
                        }.createExtension(forClassNamed: "A", categoryName: "a") { builder in
                            builder.createVoidMethod(named: "b") { method in
                                method.setAccessLevel(.private)
                            }
                        }
                }
                .createFile(named: "A+Ext") { file in
                    file.createExtension(forClassNamed: "A", categoryName: "a") { builder in
                        builder.createVoidMethod(named: "c") { method in
                            method.setAccessLevel(.private)
                        }
                    }
                }
                .build()
        let methodA = intentions.fileIntentions()[0].classIntentions[0].methods[0]
        let methodB = intentions.fileIntentions()[0].extensionIntentions[0].methods[0]
        let methodC = intentions.fileIntentions()[1].extensionIntentions[0].methods[0]
        
        XCTAssertTrue(methodA.isVisible(for: methodB))
        XCTAssertTrue(methodB.isVisible(for: methodA))
        XCTAssertFalse(methodC.isVisible(for: methodA))
        XCTAssertFalse(methodC.isVisible(for: methodB))
        XCTAssertFalse(methodA.isVisible(for: methodC))
        XCTAssertFalse(methodB.isVisible(for: methodC))
    }
}
