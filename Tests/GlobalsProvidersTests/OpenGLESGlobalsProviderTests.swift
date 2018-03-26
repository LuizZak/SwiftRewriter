import XCTest
import GlobalsProviders

class OpenGLESGlobalsProviderTests: BaseGlobalsProviderTestCase {
    override func setUp() {
        super.setUp()
        
        sut = OpenGLESGlobalsProvider()
        
        globals = sut.definitionsSource()
        types = sut.knownTypeProvider()
        typealiases = sut.typealiasProvider()
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
