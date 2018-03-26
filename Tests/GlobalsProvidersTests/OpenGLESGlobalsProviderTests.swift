import XCTest
import GlobalsProviders

class OpenGLESGlobalsProviderTests: BaseGlobalsProviderTestCase {
    override func setUp() {
        super.setUp()
        
        sut = OpenGLESGlobalsProvider()
        
        sut.registerDefinitions(on: globals)
        sut.registerTypes(in: types)
        sut.registerTypealiases(in: typealiases)
    }
    
    func testDefinedTypealiases() {
        assertDefined(typealiasFrom: "GLenum", to: "UInt32")
    }
    
    func testDefinedVars() {
        assertDefined(variable: "GL_ES_VERSION_3_0", type: .typeName("Int32"))
    }
    
    func testDefinedFunctions() {
        assertDefined(function: "glAttachShader",
                      paramTypes: [.typeName("GLuint"), .typeName("GLuint")],
                      returnType: .void)
    }
}
