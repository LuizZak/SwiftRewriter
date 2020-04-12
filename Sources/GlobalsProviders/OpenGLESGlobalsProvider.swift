import TypeSystem

public class OpenGLESGlobalsProvider: GlobalsProvider {
    private static var provider = InnerOpenGLESGlobalsProvider()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        CollectionKnownTypeProvider(knownTypes: OpenGLESGlobalsProvider.provider.types)
    }
    
    public func typealiasProvider() -> TypealiasProvider {
        CollectionTypealiasProvider(aliases: OpenGLESGlobalsProvider.provider.typealiases)
    }
    
    public func definitionsSource() -> DefinitionsSource {
        OpenGLESGlobalsProvider.provider.definitions
    }
}

// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
private class InnerOpenGLESGlobalsProvider: BaseGlobalsProvider {
    
    var definitions: ArrayDefinitionsSource = ArrayDefinitionsSource(definitions: [])
    
    override func createTypealiases() {
        addTypealias(from: "GLbitfield", to: .typeName("UInt32"))
        addTypealias(from: "GLboolean", to: .typeName("UInt8"))
        addTypealias(from: "GLbyte", to: .typeName("Int8"))
        addTypealias(from: "GLclampf", to: .typeName("Float"))
        addTypealias(from: "GLenum", to: .typeName("UInt32"))
        addTypealias(from: "GLfloat", to: .typeName("Float"))
        addTypealias(from: "GLint", to: .typeName("Int32"))
        addTypealias(from: "GLshort", to: .typeName("Int16"))
        addTypealias(from: "GLsizei", to: .typeName("Int32"))
        addTypealias(from: "GLubyte", to: .typeName("UInt8"))
        addTypealias(from: "GLuint", to: .typeName("UInt32"))
        addTypealias(from: "GLushort", to: .typeName("UInt16"))
        addTypealias(from: "GLchar", to: .typeName("Int8"))
        addTypealias(from: "GLclampx", to: .typeName("Int32"))
        addTypealias(from: "GLfixed", to: .typeName("Int32"))
        addTypealias(from: "GLhalf", to: .typeName("UInt16"))
        addTypealias(from: "GLint64", to: .typeName("Int64"))
        addTypealias(from: "GLsync", to: .typeName("OpaquePointer"))
        addTypealias(from: "GLuint64", to: .typeName("UInt64"))
        addTypealias(from: "GLintptr", to: .typeName("Int"))
        addTypealias(from: "GLsizeiptr", to: .typeName("Int"))
    }
    
    override func createDefinitions() {
        createVariableDefinitions()
        createFunctionDefinitions()
        
        definitions = ArrayDefinitionsSource(definitions: globals)
    }
    
    func createFunctionDefinitions() {
        createES1Functions()
        createES3Functions()
    }
    
    func createVariableDefinitions() {
        createES1Constants()
        createES3Constants()
    }
    
    func createES1Constants() {
        add(constant(name: "GL_VERSION_ES_CM_1_0", type: .typeName("Int32")))
        add(constant(name: "GL_VERSION_ES_CL_1_0", type: .typeName("Int32")))
        add(constant(name: "GL_VERSION_ES_CM_1_1", type: .typeName("Int32")))
        add(constant(name: "GL_VERSION_ES_CL_1_1", type: .typeName("Int32")))
        add(constant(name: "GL_OES_VERSION_1_0", type: .typeName("Int32")))
        add(constant(name: "GL_OES_VERSION_1_1", type: .typeName("Int32")))
        add(constant(name: "GL_OES_byte_coordinates", type: .typeName("Int32")))
        add(constant(name: "GL_OES_compressed_paletted_texture", type: .typeName("Int32")))
        add(constant(name: "GL_OES_draw_texture", type: .typeName("Int32")))
        add(constant(name: "GL_OES_fixed_point", type: .typeName("Int32")))
        add(constant(name: "GL_OES_matrix_get", type: .typeName("Int32")))
        add(constant(name: "GL_OES_matrix_palette", type: .typeName("Int32")))
        add(constant(name: "GL_OES_point_size_array", type: .typeName("Int32")))
        add(constant(name: "GL_OES_point_sprite", type: .typeName("Int32")))
        add(constant(name: "GL_OES_read_format", type: .typeName("Int32")))
        add(constant(name: "GL_OES_single_precision", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_BUFFER_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BUFFER_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_BUFFER_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_FALSE", type: .typeName("Int32")))
        add(constant(name: "GL_TRUE", type: .typeName("Int32")))
        add(constant(name: "GL_POINTS", type: .typeName("Int32")))
        add(constant(name: "GL_LINES", type: .typeName("Int32")))
        add(constant(name: "GL_LINE_LOOP", type: .typeName("Int32")))
        add(constant(name: "GL_LINE_STRIP", type: .typeName("Int32")))
        add(constant(name: "GL_TRIANGLES", type: .typeName("Int32")))
        add(constant(name: "GL_TRIANGLE_STRIP", type: .typeName("Int32")))
        add(constant(name: "GL_TRIANGLE_FAN", type: .typeName("Int32")))
        add(constant(name: "GL_NEVER", type: .typeName("Int32")))
        add(constant(name: "GL_LESS", type: .typeName("Int32")))
        add(constant(name: "GL_EQUAL", type: .typeName("Int32")))
        add(constant(name: "GL_LEQUAL", type: .typeName("Int32")))
        add(constant(name: "GL_GREATER", type: .typeName("Int32")))
        add(constant(name: "GL_NOTEQUAL", type: .typeName("Int32")))
        add(constant(name: "GL_GEQUAL", type: .typeName("Int32")))
        add(constant(name: "GL_ALWAYS", type: .typeName("Int32")))
        add(constant(name: "GL_ZERO", type: .typeName("Int32")))
        add(constant(name: "GL_ONE", type: .typeName("Int32")))
        add(constant(name: "GL_SRC_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_ONE_MINUS_SRC_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_SRC_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_ONE_MINUS_SRC_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_DST_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_ONE_MINUS_DST_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_DST_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_ONE_MINUS_DST_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_SRC_ALPHA_SATURATE", type: .typeName("Int32")))
        add(constant(name: "GL_CLIP_PLANE0", type: .typeName("Int32")))
        add(constant(name: "GL_CLIP_PLANE1", type: .typeName("Int32")))
        add(constant(name: "GL_CLIP_PLANE2", type: .typeName("Int32")))
        add(constant(name: "GL_CLIP_PLANE3", type: .typeName("Int32")))
        add(constant(name: "GL_CLIP_PLANE4", type: .typeName("Int32")))
        add(constant(name: "GL_CLIP_PLANE5", type: .typeName("Int32")))
        add(constant(name: "GL_FRONT", type: .typeName("Int32")))
        add(constant(name: "GL_BACK", type: .typeName("Int32")))
        add(constant(name: "GL_FRONT_AND_BACK", type: .typeName("Int32")))
        add(constant(name: "GL_FOG", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHTING", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_2D", type: .typeName("Int32")))
        add(constant(name: "GL_CULL_FACE", type: .typeName("Int32")))
        add(constant(name: "GL_ALPHA_TEST", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_LOGIC_OP", type: .typeName("Int32")))
        add(constant(name: "GL_DITHER", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_TEST", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_TEST", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SMOOTH", type: .typeName("Int32")))
        add(constant(name: "GL_LINE_SMOOTH", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_MATERIAL", type: .typeName("Int32")))
        add(constant(name: "GL_NORMALIZE", type: .typeName("Int32")))
        add(constant(name: "GL_RESCALE_NORMAL", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_NORMAL_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_COORD_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_MULTISAMPLE", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLE_ALPHA_TO_COVERAGE", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLE_ALPHA_TO_ONE", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLE_COVERAGE", type: .typeName("Int32")))
        add(constant(name: "GL_NO_ERROR", type: .typeName("Int32")))
        add(constant(name: "GL_INVALID_ENUM", type: .typeName("Int32")))
        add(constant(name: "GL_INVALID_VALUE", type: .typeName("Int32")))
        add(constant(name: "GL_INVALID_OPERATION", type: .typeName("Int32")))
        add(constant(name: "GL_STACK_OVERFLOW", type: .typeName("Int32")))
        add(constant(name: "GL_STACK_UNDERFLOW", type: .typeName("Int32")))
        add(constant(name: "GL_OUT_OF_MEMORY", type: .typeName("Int32")))
        add(constant(name: "GL_EXP", type: .typeName("Int32")))
        add(constant(name: "GL_EXP2", type: .typeName("Int32")))
        add(constant(name: "GL_FOG_DENSITY", type: .typeName("Int32")))
        add(constant(name: "GL_FOG_START", type: .typeName("Int32")))
        add(constant(name: "GL_FOG_END", type: .typeName("Int32")))
        add(constant(name: "GL_FOG_MODE", type: .typeName("Int32")))
        add(constant(name: "GL_FOG_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_CW", type: .typeName("Int32")))
        add(constant(name: "GL_CCW", type: .typeName("Int32")))
        add(constant(name: "GL_CURRENT_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_CURRENT_NORMAL", type: .typeName("Int32")))
        add(constant(name: "GL_CURRENT_TEXTURE_COORDS", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SIZE_MIN", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SIZE_MAX", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_FADE_THRESHOLD_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_DISTANCE_ATTENUATION", type: .typeName("Int32")))
        add(constant(name: "GL_SMOOTH_POINT_SIZE_RANGE", type: .typeName("Int32")))
        add(constant(name: "GL_LINE_WIDTH", type: .typeName("Int32")))
        add(constant(name: "GL_SMOOTH_LINE_WIDTH_RANGE", type: .typeName("Int32")))
        add(constant(name: "GL_ALIASED_POINT_SIZE_RANGE", type: .typeName("Int32")))
        add(constant(name: "GL_ALIASED_LINE_WIDTH_RANGE", type: .typeName("Int32")))
        add(constant(name: "GL_CULL_FACE_MODE", type: .typeName("Int32")))
        add(constant(name: "GL_FRONT_FACE", type: .typeName("Int32")))
        add(constant(name: "GL_SHADE_MODEL", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_RANGE", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_WRITEMASK", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_CLEAR_VALUE", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_FUNC", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_CLEAR_VALUE", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_FUNC", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_VALUE_MASK", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_FAIL", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_PASS_DEPTH_FAIL", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_PASS_DEPTH_PASS", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_REF", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_WRITEMASK", type: .typeName("Int32")))
        add(constant(name: "GL_MATRIX_MODE", type: .typeName("Int32")))
        add(constant(name: "GL_VIEWPORT", type: .typeName("Int32")))
        add(constant(name: "GL_MODELVIEW_STACK_DEPTH", type: .typeName("Int32")))
        add(constant(name: "GL_PROJECTION_STACK_DEPTH", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_STACK_DEPTH", type: .typeName("Int32")))
        add(constant(name: "GL_MODELVIEW_MATRIX", type: .typeName("Int32")))
        add(constant(name: "GL_PROJECTION_MATRIX", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MATRIX", type: .typeName("Int32")))
        add(constant(name: "GL_ALPHA_TEST_FUNC", type: .typeName("Int32")))
        add(constant(name: "GL_ALPHA_TEST_REF", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_DST", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_SRC", type: .typeName("Int32")))
        add(constant(name: "GL_LOGIC_OP_MODE", type: .typeName("Int32")))
        add(constant(name: "GL_SCISSOR_BOX", type: .typeName("Int32")))
        add(constant(name: "GL_SCISSOR_TEST", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_CLEAR_VALUE", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_WRITEMASK", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_LIGHTS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_CLIP_PLANES", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TEXTURE_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_MODELVIEW_STACK_DEPTH", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_PROJECTION_STACK_DEPTH", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TEXTURE_STACK_DEPTH", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VIEWPORT_DIMS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TEXTURE_UNITS", type: .typeName("Int32")))
        add(constant(name: "GL_SUBPIXEL_BITS", type: .typeName("Int32")))
        add(constant(name: "GL_RED_BITS", type: .typeName("Int32")))
        add(constant(name: "GL_GREEN_BITS", type: .typeName("Int32")))
        add(constant(name: "GL_BLUE_BITS", type: .typeName("Int32")))
        add(constant(name: "GL_ALPHA_BITS", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_BITS", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BITS", type: .typeName("Int32")))
        add(constant(name: "GL_POLYGON_OFFSET_UNITS", type: .typeName("Int32")))
        add(constant(name: "GL_POLYGON_OFFSET_FILL", type: .typeName("Int32")))
        add(constant(name: "GL_POLYGON_OFFSET_FACTOR", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_BINDING_2D", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY_STRIDE", type: .typeName("Int32")))
        add(constant(name: "GL_NORMAL_ARRAY_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_NORMAL_ARRAY_STRIDE", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ARRAY_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ARRAY_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ARRAY_STRIDE", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_COORD_ARRAY_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_COORD_ARRAY_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_COORD_ARRAY_STRIDE", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY_POINTER", type: .typeName("Int32")))
        add(constant(name: "GL_NORMAL_ARRAY_POINTER", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ARRAY_POINTER", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_COORD_ARRAY_POINTER", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLE_BUFFERS", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLES", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLE_COVERAGE_VALUE", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLE_COVERAGE_INVERT", type: .typeName("Int32")))
        add(constant(name: "GL_IMPLEMENTATION_COLOR_READ_TYPE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_IMPLEMENTATION_COLOR_READ_FORMAT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_NUM_COMPRESSED_TEXTURE_FORMATS", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_TEXTURE_FORMATS", type: .typeName("Int32")))
        add(constant(name: "GL_DONT_CARE", type: .typeName("Int32")))
        add(constant(name: "GL_FASTEST", type: .typeName("Int32")))
        add(constant(name: "GL_NICEST", type: .typeName("Int32")))
        add(constant(name: "GL_PERSPECTIVE_CORRECTION_HINT", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SMOOTH_HINT", type: .typeName("Int32")))
        add(constant(name: "GL_LINE_SMOOTH_HINT", type: .typeName("Int32")))
        add(constant(name: "GL_FOG_HINT", type: .typeName("Int32")))
        add(constant(name: "GL_GENERATE_MIPMAP_HINT", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT_MODEL_AMBIENT", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT_MODEL_TWO_SIDE", type: .typeName("Int32")))
        add(constant(name: "GL_AMBIENT", type: .typeName("Int32")))
        add(constant(name: "GL_DIFFUSE", type: .typeName("Int32")))
        add(constant(name: "GL_SPECULAR", type: .typeName("Int32")))
        add(constant(name: "GL_POSITION", type: .typeName("Int32")))
        add(constant(name: "GL_SPOT_DIRECTION", type: .typeName("Int32")))
        add(constant(name: "GL_SPOT_EXPONENT", type: .typeName("Int32")))
        add(constant(name: "GL_SPOT_CUTOFF", type: .typeName("Int32")))
        add(constant(name: "GL_CONSTANT_ATTENUATION", type: .typeName("Int32")))
        add(constant(name: "GL_LINEAR_ATTENUATION", type: .typeName("Int32")))
        add(constant(name: "GL_QUADRATIC_ATTENUATION", type: .typeName("Int32")))
        add(constant(name: "GL_BYTE", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_BYTE", type: .typeName("Int32")))
        add(constant(name: "GL_SHORT", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT", type: .typeName("Int32")))
        add(constant(name: "GL_FIXED", type: .typeName("Int32")))
        add(constant(name: "GL_CLEAR", type: .typeName("Int32")))
        add(constant(name: "GL_AND", type: .typeName("Int32")))
        add(constant(name: "GL_AND_REVERSE", type: .typeName("Int32")))
        add(constant(name: "GL_COPY", type: .typeName("Int32")))
        add(constant(name: "GL_AND_INVERTED", type: .typeName("Int32")))
        add(constant(name: "GL_NOOP", type: .typeName("Int32")))
        add(constant(name: "GL_XOR", type: .typeName("Int32")))
        add(constant(name: "GL_OR", type: .typeName("Int32")))
        add(constant(name: "GL_NOR", type: .typeName("Int32")))
        add(constant(name: "GL_EQUIV", type: .typeName("Int32")))
        add(constant(name: "GL_INVERT", type: .typeName("Int32")))
        add(constant(name: "GL_OR_REVERSE", type: .typeName("Int32")))
        add(constant(name: "GL_COPY_INVERTED", type: .typeName("Int32")))
        add(constant(name: "GL_OR_INVERTED", type: .typeName("Int32")))
        add(constant(name: "GL_NAND", type: .typeName("Int32")))
        add(constant(name: "GL_SET", type: .typeName("Int32")))
        add(constant(name: "GL_EMISSION", type: .typeName("Int32")))
        add(constant(name: "GL_SHININESS", type: .typeName("Int32")))
        add(constant(name: "GL_AMBIENT_AND_DIFFUSE", type: .typeName("Int32")))
        add(constant(name: "GL_MODELVIEW", type: .typeName("Int32")))
        add(constant(name: "GL_PROJECTION", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE", type: .typeName("Int32")))
        add(constant(name: "GL_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA", type: .typeName("Int32")))
        add(constant(name: "GL_LUMINANCE", type: .typeName("Int32")))
        add(constant(name: "GL_LUMINANCE_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_UNPACK_ALIGNMENT", type: .typeName("Int32")))
        add(constant(name: "GL_PACK_ALIGNMENT", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT_4_4_4_4", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT_5_5_5_1", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT_5_6_5", type: .typeName("Int32")))
        add(constant(name: "GL_FLAT", type: .typeName("Int32")))
        add(constant(name: "GL_SMOOTH", type: .typeName("Int32")))
        add(constant(name: "GL_KEEP", type: .typeName("Int32")))
        add(constant(name: "GL_REPLACE", type: .typeName("Int32")))
        add(constant(name: "GL_INCR", type: .typeName("Int32")))
        add(constant(name: "GL_DECR", type: .typeName("Int32")))
        add(constant(name: "GL_VENDOR", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERER", type: .typeName("Int32")))
        add(constant(name: "GL_VERSION", type: .typeName("Int32")))
        add(constant(name: "GL_EXTENSIONS", type: .typeName("Int32")))
        add(constant(name: "GL_MODULATE", type: .typeName("Int32")))
        add(constant(name: "GL_DECAL", type: .typeName("Int32")))
        add(constant(name: "GL_ADD", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_ENV_MODE", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_ENV_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_ENV", type: .typeName("Int32")))
        add(constant(name: "GL_NEAREST", type: .typeName("Int32")))
        add(constant(name: "GL_LINEAR", type: .typeName("Int32")))
        add(constant(name: "GL_NEAREST_MIPMAP_NEAREST", type: .typeName("Int32")))
        add(constant(name: "GL_LINEAR_MIPMAP_NEAREST", type: .typeName("Int32")))
        add(constant(name: "GL_NEAREST_MIPMAP_LINEAR", type: .typeName("Int32")))
        add(constant(name: "GL_LINEAR_MIPMAP_LINEAR", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MAG_FILTER", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MIN_FILTER", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_WRAP_S", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_WRAP_T", type: .typeName("Int32")))
        add(constant(name: "GL_GENERATE_MIPMAP", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE0", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE1", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE2", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE3", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE4", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE5", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE6", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE7", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE8", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE9", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE10", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE11", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE12", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE13", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE14", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE15", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE16", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE17", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE18", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE19", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE20", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE21", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE22", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE23", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE24", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE25", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE26", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE27", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE28", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE29", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE30", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE31", type: .typeName("Int32")))
        add(constant(name: "GL_ACTIVE_TEXTURE", type: .typeName("Int32")))
        add(constant(name: "GL_CLIENT_ACTIVE_TEXTURE", type: .typeName("Int32")))
        add(constant(name: "GL_REPEAT", type: .typeName("Int32")))
        add(constant(name: "GL_CLAMP_TO_EDGE", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE4_RGB8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE4_RGBA8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE4_R5_G6_B5_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE4_RGBA4_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE4_RGB5_A1_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE8_RGB8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE8_RGBA8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE8_R5_G6_B5_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE8_RGBA4_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PALETTE8_RGB5_A1_OES", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT0", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT1", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT2", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT3", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT4", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT5", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT6", type: .typeName("Int32")))
        add(constant(name: "GL_LIGHT7", type: .typeName("Int32")))
        add(constant(name: "GL_ARRAY_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_ELEMENT_ARRAY_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_ARRAY_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_ELEMENT_ARRAY_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_NORMAL_ARRAY_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ARRAY_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_STATIC_DRAW", type: .typeName("Int32")))
        add(constant(name: "GL_DYNAMIC_DRAW", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_USAGE", type: .typeName("Int32")))
        add(constant(name: "GL_SUBTRACT", type: .typeName("Int32")))
        add(constant(name: "GL_COMBINE", type: .typeName("Int32")))
        add(constant(name: "GL_COMBINE_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_COMBINE_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_RGB_SCALE", type: .typeName("Int32")))
        add(constant(name: "GL_ADD_SIGNED", type: .typeName("Int32")))
        add(constant(name: "GL_INTERPOLATE", type: .typeName("Int32")))
        add(constant(name: "GL_CONSTANT", type: .typeName("Int32")))
        add(constant(name: "GL_PRIMARY_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_PREVIOUS", type: .typeName("Int32")))
        add(constant(name: "GL_OPERAND0_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_OPERAND1_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_OPERAND2_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_OPERAND0_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_OPERAND1_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_OPERAND2_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_ALPHA_SCALE", type: .typeName("Int32")))
        add(constant(name: "GL_SRC0_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_SRC1_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_SRC2_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_SRC0_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_SRC1_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_SRC2_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_DOT3_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_DOT3_RGBA", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_CROP_RECT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MODELVIEW_MATRIX_FLOAT_AS_INT_BITS_OES", type: .typeName("Int32")))
        add(constant(name: "GL_PROJECTION_MATRIX_FLOAT_AS_INT_BITS_OES", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MATRIX_FLOAT_AS_INT_BITS_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VERTEX_UNITS_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_PALETTE_MATRICES_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MATRIX_PALETTE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MATRIX_INDEX_ARRAY_OES", type: .typeName("Int32")))
        add(constant(name: "GL_WEIGHT_ARRAY_OES", type: .typeName("Int32")))
        add(constant(name: "GL_CURRENT_PALETTE_MATRIX_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MATRIX_INDEX_ARRAY_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MATRIX_INDEX_ARRAY_TYPE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MATRIX_INDEX_ARRAY_STRIDE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MATRIX_INDEX_ARRAY_POINTER_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MATRIX_INDEX_ARRAY_BUFFER_BINDING_OES", type: .typeName("Int32")))
        add(constant(name: "GL_WEIGHT_ARRAY_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_WEIGHT_ARRAY_TYPE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_WEIGHT_ARRAY_STRIDE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_WEIGHT_ARRAY_POINTER_OES", type: .typeName("Int32")))
        add(constant(name: "GL_WEIGHT_ARRAY_BUFFER_BINDING_OES", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SIZE_ARRAY_OES", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SIZE_ARRAY_TYPE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SIZE_ARRAY_STRIDE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SIZE_ARRAY_POINTER_OES", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SIZE_ARRAY_BUFFER_BINDING_OES", type: .typeName("Int32")))
        add(constant(name: "GL_POINT_SPRITE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_COORD_REPLACE_OES", type: .typeName("Int32")))
    }
    
    func createES3Constants() {
        add(constant(name: "GL_ES_VERSION_3_0", type: .typeName("Int32")))
        add(constant(name: "GL_ES_VERSION_2_0", type: .typeName("Int32")))
        add(constant(name: "GL_FUNC_ADD", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_EQUATION", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_EQUATION_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_EQUATION_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_FUNC_SUBTRACT", type: .typeName("Int32")))
        add(constant(name: "GL_FUNC_REVERSE_SUBTRACT", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_DST_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_SRC_RGB", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_DST_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_SRC_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_CONSTANT_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_ONE_MINUS_CONSTANT_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_CONSTANT_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_ONE_MINUS_CONSTANT_ALPHA", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_STREAM_DRAW", type: .typeName("Int32")))
        add(constant(name: "GL_CURRENT_VERTEX_ATTRIB", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BACK_FUNC", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BACK_FAIL", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BACK_PASS_DEPTH_FAIL", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BACK_PASS_DEPTH_PASS", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BACK_REF", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BACK_VALUE_MASK", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_BACK_WRITEMASK", type: .typeName("Int32")))
        add(constant(name: "GL_INT", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_COMPONENT", type: .typeName("Int32")))
        add(constant(name: "GL_FRAGMENT_SHADER", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_SHADER", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VERTEX_ATTRIBS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VERTEX_UNIFORM_VECTORS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VARYING_VECTORS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TEXTURE_IMAGE_UNITS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_FRAGMENT_UNIFORM_VECTORS", type: .typeName("Int32")))
        add(constant(name: "GL_SHADER_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_DELETE_STATUS", type: .typeName("Int32")))
        add(constant(name: "GL_LINK_STATUS", type: .typeName("Int32")))
        add(constant(name: "GL_VALIDATE_STATUS", type: .typeName("Int32")))
        add(constant(name: "GL_ATTACHED_SHADERS", type: .typeName("Int32")))
        add(constant(name: "GL_ACTIVE_UNIFORMS", type: .typeName("Int32")))
        add(constant(name: "GL_ACTIVE_UNIFORM_MAX_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_ACTIVE_ATTRIBUTES", type: .typeName("Int32")))
        add(constant(name: "GL_ACTIVE_ATTRIBUTE_MAX_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_SHADING_LANGUAGE_VERSION", type: .typeName("Int32")))
        add(constant(name: "GL_CURRENT_PROGRAM", type: .typeName("Int32")))
        add(constant(name: "GL_INCR_WRAP", type: .typeName("Int32")))
        add(constant(name: "GL_DECR_WRAP", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_CUBE_MAP", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_BINDING_CUBE_MAP", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_CUBE_MAP_POSITIVE_X", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_CUBE_MAP_NEGATIVE_X", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_CUBE_MAP_POSITIVE_Y", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_CUBE_MAP_NEGATIVE_Y", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_CUBE_MAP_POSITIVE_Z", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_CUBE_MAP_NEGATIVE_Z", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_CUBE_MAP_TEXTURE_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_MIRRORED_REPEAT", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_VEC2", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_VEC3", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_VEC4", type: .typeName("Int32")))
        add(constant(name: "GL_INT_VEC2", type: .typeName("Int32")))
        add(constant(name: "GL_INT_VEC3", type: .typeName("Int32")))
        add(constant(name: "GL_INT_VEC4", type: .typeName("Int32")))
        add(constant(name: "GL_BOOL", type: .typeName("Int32")))
        add(constant(name: "GL_BOOL_VEC2", type: .typeName("Int32")))
        add(constant(name: "GL_BOOL_VEC3", type: .typeName("Int32")))
        add(constant(name: "GL_BOOL_VEC4", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT2", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT3", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT4", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLER_2D", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLER_CUBE", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_ENABLED", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_STRIDE", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_NORMALIZED", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_POINTER", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_IMPLEMENTATION_COLOR_READ_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_IMPLEMENTATION_COLOR_READ_FORMAT", type: .typeName("Int32")))
        add(constant(name: "GL_COMPILE_STATUS", type: .typeName("Int32")))
        add(constant(name: "GL_INFO_LOG_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_SHADER_SOURCE_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_SHADER_COMPILER", type: .typeName("Int32")))
        add(constant(name: "GL_SHADER_BINARY_FORMATS", type: .typeName("Int32")))
        add(constant(name: "GL_NUM_SHADER_BINARY_FORMATS", type: .typeName("Int32")))
        add(constant(name: "GL_LOW_FLOAT", type: .typeName("Int32")))
        add(constant(name: "GL_MEDIUM_FLOAT", type: .typeName("Int32")))
        add(constant(name: "GL_HIGH_FLOAT", type: .typeName("Int32")))
        add(constant(name: "GL_LOW_INT", type: .typeName("Int32")))
        add(constant(name: "GL_MEDIUM_INT", type: .typeName("Int32")))
        add(constant(name: "GL_HIGH_INT", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA4", type: .typeName("Int32")))
        add(constant(name: "GL_RGB5_A1", type: .typeName("Int32")))
        add(constant(name: "GL_RGB565", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_COMPONENT16", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_INDEX8", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_WIDTH", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_HEIGHT", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_INTERNAL_FORMAT", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_RED_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_GREEN_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_BLUE_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_ALPHA_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_DEPTH_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_STENCIL_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT0", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_ATTACHMENT", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_ATTACHMENT", type: .typeName("Int32")))
        add(constant(name: "GL_NONE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_COMPLETE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_UNSUPPORTED", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_RENDERBUFFER_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_INVALID_FRAMEBUFFER_OPERATION", type: .typeName("Int32")))
        add(constant(name: "GL_READ_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_UNPACK_ROW_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_UNPACK_SKIP_ROWS", type: .typeName("Int32")))
        add(constant(name: "GL_UNPACK_SKIP_PIXELS", type: .typeName("Int32")))
        add(constant(name: "GL_PACK_ROW_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_PACK_SKIP_ROWS", type: .typeName("Int32")))
        add(constant(name: "GL_PACK_SKIP_PIXELS", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL", type: .typeName("Int32")))
        add(constant(name: "GL_RED", type: .typeName("Int32")))
        add(constant(name: "GL_RGB8", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA8", type: .typeName("Int32")))
        add(constant(name: "GL_RGB10_A2", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_BINDING_3D", type: .typeName("Int32")))
        add(constant(name: "GL_UNPACK_SKIP_IMAGES", type: .typeName("Int32")))
        add(constant(name: "GL_UNPACK_IMAGE_HEIGHT", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_3D", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_WRAP_R", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_3D_TEXTURE_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_2_10_10_10_REV", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_ELEMENTS_VERTICES", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_ELEMENTS_INDICES", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MIN_LOD", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MAX_LOD", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_BASE_LEVEL", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MAX_LEVEL", type: .typeName("Int32")))
        add(constant(name: "GL_MIN", type: .typeName("Int32")))
        add(constant(name: "GL_MAX", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_COMPONENT24", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TEXTURE_LOD_BIAS", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_COMPARE_MODE", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_COMPARE_FUNC", type: .typeName("Int32")))
        add(constant(name: "GL_CURRENT_QUERY", type: .typeName("Int32")))
        add(constant(name: "GL_QUERY_RESULT", type: .typeName("Int32")))
        add(constant(name: "GL_QUERY_RESULT_AVAILABLE", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_MAPPED", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_MAP_POINTER", type: .typeName("Int32")))
        add(constant(name: "GL_STREAM_READ", type: .typeName("Int32")))
        add(constant(name: "GL_STREAM_COPY", type: .typeName("Int32")))
        add(constant(name: "GL_STATIC_READ", type: .typeName("Int32")))
        add(constant(name: "GL_STATIC_COPY", type: .typeName("Int32")))
        add(constant(name: "GL_DYNAMIC_READ", type: .typeName("Int32")))
        add(constant(name: "GL_DYNAMIC_COPY", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_DRAW_BUFFERS", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER0", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER1", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER2", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER3", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER4", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER5", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER6", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER7", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER8", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER9", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER10", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER11", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER12", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER13", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER14", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_BUFFER15", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_FRAGMENT_UNIFORM_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VERTEX_UNIFORM_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLER_3D", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLER_2D_SHADOW", type: .typeName("Int32")))
        add(constant(name: "GL_FRAGMENT_SHADER_DERIVATIVE_HINT", type: .typeName("Int32")))
        add(constant(name: "GL_PIXEL_PACK_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_PIXEL_UNPACK_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_PIXEL_PACK_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_PIXEL_UNPACK_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT2x3", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT2x4", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT3x2", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT3x4", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT4x2", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_MAT4x3", type: .typeName("Int32")))
        add(constant(name: "GL_SRGB", type: .typeName("Int32")))
        add(constant(name: "GL_SRGB8", type: .typeName("Int32")))
        add(constant(name: "GL_SRGB8_ALPHA8", type: .typeName("Int32")))
        add(constant(name: "GL_COMPARE_REF_TO_TEXTURE", type: .typeName("Int32")))
        add(constant(name: "GL_MAJOR_VERSION", type: .typeName("Int32")))
        add(constant(name: "GL_MINOR_VERSION", type: .typeName("Int32")))
        add(constant(name: "GL_NUM_EXTENSIONS", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA32F", type: .typeName("Int32")))
        add(constant(name: "GL_RGB32F", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA16F", type: .typeName("Int32")))
        add(constant(name: "GL_RGB16F", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_INTEGER", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_ARRAY_TEXTURE_LAYERS", type: .typeName("Int32")))
        add(constant(name: "GL_MIN_PROGRAM_TEXEL_OFFSET", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_PROGRAM_TEXEL_OFFSET", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VARYING_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_2D_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_BINDING_2D_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_R11F_G11F_B10F", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_10F_11F_11F_REV", type: .typeName("Int32")))
        add(constant(name: "GL_RGB9_E5", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_5_9_9_9_REV", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_BUFFER_MODE", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_VARYINGS", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_BUFFER_START", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_BUFFER_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN", type: .typeName("Int32")))
        add(constant(name: "GL_RASTERIZER_DISCARD", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS", type: .typeName("Int32")))
        add(constant(name: "GL_INTERLEAVED_ATTRIBS", type: .typeName("Int32")))
        add(constant(name: "GL_SEPARATE_ATTRIBS", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA32UI", type: .typeName("Int32")))
        add(constant(name: "GL_RGB32UI", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA16UI", type: .typeName("Int32")))
        add(constant(name: "GL_RGB16UI", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA8UI", type: .typeName("Int32")))
        add(constant(name: "GL_RGB8UI", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA32I", type: .typeName("Int32")))
        add(constant(name: "GL_RGB32I", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA16I", type: .typeName("Int32")))
        add(constant(name: "GL_RGB16I", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA8I", type: .typeName("Int32")))
        add(constant(name: "GL_RGB8I", type: .typeName("Int32")))
        add(constant(name: "GL_RED_INTEGER", type: .typeName("Int32")))
        add(constant(name: "GL_RGB_INTEGER", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA_INTEGER", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLER_2D_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLER_2D_ARRAY_SHADOW", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLER_CUBE_SHADOW", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_VEC2", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_VEC3", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_VEC4", type: .typeName("Int32")))
        add(constant(name: "GL_INT_SAMPLER_2D", type: .typeName("Int32")))
        add(constant(name: "GL_INT_SAMPLER_3D", type: .typeName("Int32")))
        add(constant(name: "GL_INT_SAMPLER_CUBE", type: .typeName("Int32")))
        add(constant(name: "GL_INT_SAMPLER_2D_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_SAMPLER_2D", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_SAMPLER_3D", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_SAMPLER_CUBE", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_SAMPLER_2D_ARRAY", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_ACCESS_FLAGS", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_MAP_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_MAP_OFFSET", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_COMPONENT32F", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH32F_STENCIL8", type: .typeName("Int32")))
        add(constant(name: "GL_FLOAT_32_UNSIGNED_INT_24_8_REV", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_DEFAULT", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_UNDEFINED", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_STENCIL_ATTACHMENT", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_STENCIL", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_24_8", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH24_STENCIL8", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_NORMALIZED", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_FRAMEBUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_READ_FRAMEBUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_FRAMEBUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_READ_FRAMEBUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_SAMPLES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_COLOR_ATTACHMENTS", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT1", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT2", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT3", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT4", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT5", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT6", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT7", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT8", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT9", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT10", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT11", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT12", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT13", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT14", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT15", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_SAMPLES", type: .typeName("Int32")))
        add(constant(name: "GL_HALF_FLOAT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_READ_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_WRITE_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_INVALIDATE_RANGE_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_INVALIDATE_BUFFER_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_FLUSH_EXPLICIT_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_UNSYNCHRONIZED_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_RG", type: .typeName("Int32")))
        add(constant(name: "GL_RG_INTEGER", type: .typeName("Int32")))
        add(constant(name: "GL_R8", type: .typeName("Int32")))
        add(constant(name: "GL_RG8", type: .typeName("Int32")))
        add(constant(name: "GL_R16F", type: .typeName("Int32")))
        add(constant(name: "GL_R32F", type: .typeName("Int32")))
        add(constant(name: "GL_RG16F", type: .typeName("Int32")))
        add(constant(name: "GL_RG32F", type: .typeName("Int32")))
        add(constant(name: "GL_R8I", type: .typeName("Int32")))
        add(constant(name: "GL_R8UI", type: .typeName("Int32")))
        add(constant(name: "GL_R16I", type: .typeName("Int32")))
        add(constant(name: "GL_R16UI", type: .typeName("Int32")))
        add(constant(name: "GL_R32I", type: .typeName("Int32")))
        add(constant(name: "GL_R32UI", type: .typeName("Int32")))
        add(constant(name: "GL_RG8I", type: .typeName("Int32")))
        add(constant(name: "GL_RG8UI", type: .typeName("Int32")))
        add(constant(name: "GL_RG16I", type: .typeName("Int32")))
        add(constant(name: "GL_RG16UI", type: .typeName("Int32")))
        add(constant(name: "GL_RG32I", type: .typeName("Int32")))
        add(constant(name: "GL_RG32UI", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_R8_SNORM", type: .typeName("Int32")))
        add(constant(name: "GL_RG8_SNORM", type: .typeName("Int32")))
        add(constant(name: "GL_RGB8_SNORM", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA8_SNORM", type: .typeName("Int32")))
        add(constant(name: "GL_SIGNED_NORMALIZED", type: .typeName("Int32")))
        add(constant(name: "GL_PRIMITIVE_RESTART_FIXED_INDEX", type: .typeName("Int32")))
        add(constant(name: "GL_COPY_READ_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_COPY_WRITE_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_COPY_READ_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_COPY_WRITE_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BUFFER", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BUFFER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BUFFER_START", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BUFFER_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_VERTEX_UNIFORM_BLOCKS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_FRAGMENT_UNIFORM_BLOCKS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_COMBINED_UNIFORM_BLOCKS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_UNIFORM_BUFFER_BINDINGS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_UNIFORM_BLOCK_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT", type: .typeName("Int32")))
        add(constant(name: "GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_ACTIVE_UNIFORM_BLOCKS", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_NAME_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BLOCK_INDEX", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_OFFSET", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_ARRAY_STRIDE", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_MATRIX_STRIDE", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_IS_ROW_MAJOR", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BLOCK_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BLOCK_DATA_SIZE", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BLOCK_NAME_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER", type: .typeName("Int32")))
        add(constant(name: "GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER", type: .typeName("Int32")))
        add(constant(name: "GL_INVALID_INDEX", type: .typeName("UInt32")))
        add(constant(name: "GL_MAX_VERTEX_OUTPUT_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_FRAGMENT_INPUT_COMPONENTS", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_SERVER_WAIT_TIMEOUT", type: .typeName("Int32")))
        add(constant(name: "GL_OBJECT_TYPE", type: .typeName("Int32")))
        add(constant(name: "GL_SYNC_CONDITION", type: .typeName("Int32")))
        add(constant(name: "GL_SYNC_STATUS", type: .typeName("Int32")))
        add(constant(name: "GL_SYNC_FLAGS", type: .typeName("Int32")))
        add(constant(name: "GL_SYNC_FENCE", type: .typeName("Int32")))
        add(constant(name: "GL_SYNC_GPU_COMMANDS_COMPLETE", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNALED", type: .typeName("Int32")))
        add(constant(name: "GL_SIGNALED", type: .typeName("Int32")))
        add(constant(name: "GL_ALREADY_SIGNALED", type: .typeName("Int32")))
        add(constant(name: "GL_TIMEOUT_EXPIRED", type: .typeName("Int32")))
        add(constant(name: "GL_CONDITION_SATISFIED", type: .typeName("Int32")))
        add(constant(name: "GL_WAIT_FAILED", type: .typeName("Int32")))
        add(constant(name: "GL_SYNC_FLUSH_COMMANDS_BIT", type: .typeName("Int32")))
        add(constant(name: "GL_TIMEOUT_IGNORED", type: .typeName("UInt64")))
        add(constant(name: "GL_VERTEX_ATTRIB_ARRAY_DIVISOR", type: .typeName("Int32")))
        add(constant(name: "GL_ANY_SAMPLES_PASSED", type: .typeName("Int32")))
        add(constant(name: "GL_ANY_SAMPLES_PASSED_CONSERVATIVE", type: .typeName("Int32")))
        add(constant(name: "GL_SAMPLER_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_RGB10_A2UI", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_SWIZZLE_R", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_SWIZZLE_G", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_SWIZZLE_B", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_SWIZZLE_A", type: .typeName("Int32")))
        add(constant(name: "GL_GREEN", type: .typeName("Int32")))
        add(constant(name: "GL_BLUE", type: .typeName("Int32")))
        add(constant(name: "GL_INT_2_10_10_10_REV", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_PAUSED", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_ACTIVE", type: .typeName("Int32")))
        add(constant(name: "GL_TRANSFORM_FEEDBACK_BINDING", type: .typeName("Int32")))
        add(constant(name: "GL_PROGRAM_BINARY_RETRIEVABLE_HINT", type: .typeName("Int32")))
        add(constant(name: "GL_PROGRAM_BINARY_LENGTH", type: .typeName("Int32")))
        add(constant(name: "GL_NUM_PROGRAM_BINARY_FORMATS", type: .typeName("Int32")))
        add(constant(name: "GL_PROGRAM_BINARY_FORMATS", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_R11_EAC", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_SIGNED_R11_EAC", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_RG11_EAC", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_SIGNED_RG11_EAC", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_RGB8_ETC2", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_SRGB8_ETC2", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_RGBA8_ETC2_EAC", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_IMMUTABLE_FORMAT", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_ELEMENT_INDEX", type: .typeName("Int32")))
        add(constant(name: "GL_NUM_SAMPLE_COUNTS", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_IMMUTABLE_LEVELS", type: .typeName("Int32")))
        
        // Extended OpenGLES
        add(constant(name: "GL_APPLE_copy_texture_levels", type: .typeName("Int32")))
        add(constant(name: "GL_APPLE_framebuffer_multisample", type: .typeName("Int32")))
        add(constant(name: "GL_APPLE_texture_2D_limited_npot", type: .typeName("Int32")))
        add(constant(name: "GL_APPLE_texture_format_BGRA8888", type: .typeName("Int32")))
        add(constant(name: "GL_APPLE_texture_max_level", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_blend_minmax", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_debug_label", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_debug_marker", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_discard_framebuffer", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_map_buffer_range", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_read_format_bgra", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_texture_filter_anisotropic", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_texture_lod_bias", type: .typeName("Int32")))
        add(constant(name: "GL_EXT_texture_storage", type: .typeName("Int32")))
        add(constant(name: "GL_IMG_read_format", type: .typeName("Int32")))
        add(constant(name: "GL_IMG_texture_compression_pvrtc", type: .typeName("Int32")))
        add(constant(name: "GL_OES_blend_equation_separate", type: .typeName("Int32")))
        add(constant(name: "GL_OES_blend_func_separate", type: .typeName("Int32")))
        add(constant(name: "GL_OES_blend_subtract", type: .typeName("Int32")))
        add(constant(name: "GL_OES_depth24", type: .typeName("Int32")))
        add(constant(name: "GL_OES_element_index_uint", type: .typeName("Int32")))
        add(constant(name: "GL_OES_fbo_render_mipmap", type: .typeName("Int32")))
        add(constant(name: "GL_OES_framebuffer_object", type: .typeName("Int32")))
        add(constant(name: "GL_OES_mapbuffer", type: .typeName("Int32")))
        add(constant(name: "GL_OES_packed_depth_stencil", type: .typeName("Int32")))
        add(constant(name: "GL_OES_rgb8_rgba8", type: .typeName("Int32")))
        add(constant(name: "GL_OES_stencil_wrap", type: .typeName("Int32")))
        add(constant(name: "GL_OES_stencil8", type: .typeName("Int32")))
        add(constant(name: "GL_OES_texture_mirrored_repeat", type: .typeName("Int32")))
        add(constant(name: "GL_OES_vertex_array_object", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_SAMPLES_APPLE", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_APPLE", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_SAMPLES_APPLE", type: .typeName("Int32")))
        add(constant(name: "GL_READ_FRAMEBUFFER_APPLE", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_FRAMEBUFFER_APPLE", type: .typeName("Int32")))
        add(constant(name: "GL_DRAW_FRAMEBUFFER_BINDING_APPLE", type: .typeName("Int32")))
        add(constant(name: "GL_READ_FRAMEBUFFER_BINDING_APPLE", type: .typeName("Int32")))
        add(constant(name: "GL_BGRA_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_BGRA", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MAX_LEVEL_APPLE", type: .typeName("Int32")))
        add(constant(name: "GL_MIN_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_OBJECT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY_OBJECT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_READ_BIT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_WRITE_BIT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_INVALIDATE_RANGE_BIT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_INVALIDATE_BUFFER_BIT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_FLUSH_EXPLICIT_BIT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAP_UNSYNCHRONIZED_BIT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT_4_4_4_4_REV_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT_1_5_5_5_REV_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT_1_5_5_5_REV", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT_4_4_4_4_REV", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_MAX_ANISOTROPY_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_TEXTURE_LOD_BIAS_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_FILTER_CONTROL_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_LOD_BIAS_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_TEXTURE_IMMUTABLE_FORMAT_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_ALPHA8_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_LUMINANCE8_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_LUMINANCE8_ALPHA8_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_BGRA8_EXT", type: .typeName("Int32")))
        add(constant(name: "GL_BGRA_IMG", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_SHORT_4_4_4_4_REV_IMG", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG", type: .typeName("Int32")))
        add(constant(name: "GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_EQUATION_RGB_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_EQUATION_ALPHA_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_DST_RGB_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_SRC_RGB_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_DST_ALPHA_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_SRC_ALPHA_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BLEND_EQUATION_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FUNC_ADD_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FUNC_SUBTRACT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FUNC_REVERSE_SUBTRACT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_COMPONENT24_OES", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA4_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RGB5_A1_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RGB565_OES", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_COMPONENT16_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_WIDTH_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_HEIGHT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_INTERNAL_FORMAT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_RED_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_GREEN_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_BLUE_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_ALPHA_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_DEPTH_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_STENCIL_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_COLOR_ATTACHMENT0_OES", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_ATTACHMENT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_ATTACHMENT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_COMPLETE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_INCOMPLETE_FORMATS_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_UNSUPPORTED_OES", type: .typeName("Int32")))
        add(constant(name: "GL_FRAMEBUFFER_BINDING_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RENDERBUFFER_BINDING_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MAX_RENDERBUFFER_SIZE_OES", type: .typeName("Int32")))
        add(constant(name: "GL_INVALID_FRAMEBUFFER_OPERATION_OES", type: .typeName("Int32")))
        add(constant(name: "GL_WRITE_ONLY_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_ACCESS_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_MAPPED_OES", type: .typeName("Int32")))
        add(constant(name: "GL_BUFFER_MAP_POINTER_OES", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH_STENCIL_OES", type: .typeName("Int32")))
        add(constant(name: "GL_UNSIGNED_INT_24_8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_DEPTH24_STENCIL8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RGB8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_RGBA8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_INCR_WRAP_OES", type: .typeName("Int32")))
        add(constant(name: "GL_DECR_WRAP_OES", type: .typeName("Int32")))
        add(constant(name: "GL_STENCIL_INDEX8_OES", type: .typeName("Int32")))
        add(constant(name: "GL_MIRRORED_REPEAT_OES", type: .typeName("Int32")))
        add(constant(name: "GL_VERTEX_ARRAY_BINDING_OES", type: .typeName("Int32")))
    }
    
    func createES1Functions() {
                add(function(name: "glAlphaFunc",
                     paramsSignature: "(_ func: GLenum, _ ref: GLclampf)"))
        add(function(name: "glClearColor",
                     paramsSignature: "(_ red: GLclampf, _ green: GLclampf, _ blue: GLclampf, _ alpha: GLclampf)"))
        add(function(name: "glClearDepthf",
                     paramsSignature: "(_ depth: GLclampf)"))
        add(function(name: "glClipPlanef",
                     paramsSignature: "(_ plane: GLenum, _ equation: UnsafePointer<GLfloat>!)"))
        add(function(name: "glColor4f",
                     paramsSignature: "(_ red: GLfloat, _ green: GLfloat, _ blue: GLfloat, _ alpha: GLfloat)"))
        add(function(name: "glDepthRangef",
                     paramsSignature: "(_ zNear: GLclampf, _ zFar: GLclampf)"))
        add(function(name: "glFogf",
                     paramsSignature: "(_ pname: GLenum, _ param: GLfloat)"))
        add(function(name: "glFogfv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafePointer<GLfloat>!)"))
        add(function(name: "glFrustumf",
                     paramsSignature: "(_ left: GLfloat, _ right: GLfloat, _ bottom: GLfloat, _ top: GLfloat, _ zNear: GLfloat, _ zFar: GLfloat)"))
        add(function(name: "glGetClipPlanef",
                     paramsSignature: "(_ pname: GLenum, _ equation: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glGetFloatv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glGetLightfv",
                     paramsSignature: "(_ light: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glGetMaterialfv",
                     paramsSignature: "(_ face: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glGetTexEnvfv",
                     paramsSignature: "(_ env: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glGetTexParameterfv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glLightModelf",
                     paramsSignature: "(_ pname: GLenum, _ param: GLfloat)"))
        add(function(name: "glLightModelfv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafePointer<GLfloat>!)"))
        add(function(name: "glLightf",
                     paramsSignature: "(_ light: GLenum, _ pname: GLenum, _ param: GLfloat)"))
        add(function(name: "glLightfv",
                     paramsSignature: "(_ light: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLfloat>!)"))
        add(function(name: "glLineWidth",
                     paramsSignature: "(_ width: GLfloat)"))
        add(function(name: "glLoadMatrixf",
                     paramsSignature: "(_ m: UnsafePointer<GLfloat>!)"))
        add(function(name: "glMaterialf",
                     paramsSignature: "(_ face: GLenum, _ pname: GLenum, _ param: GLfloat)"))
        add(function(name: "glMaterialfv",
                     paramsSignature: "(_ face: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLfloat>!)"))
        add(function(name: "glMultMatrixf",
                     paramsSignature: "(_ m: UnsafePointer<GLfloat>!)"))
        add(function(name: "glMultiTexCoord4f",
                     paramsSignature: "(_ target: GLenum, _ s: GLfloat, _ t: GLfloat, _ r: GLfloat, _ q: GLfloat)"))
        add(function(name: "glNormal3f",
                     paramsSignature: "(_ nx: GLfloat, _ ny: GLfloat, _ nz: GLfloat)"))
        add(function(name: "glOrthof",
                     paramsSignature: "(_ left: GLfloat, _ right: GLfloat, _ bottom: GLfloat, _ top: GLfloat, _ zNear: GLfloat, _ zFar: GLfloat)"))
        add(function(name: "glPointParameterf",
                     paramsSignature: "(_ pname: GLenum, _ param: GLfloat)"))
        add(function(name: "glPointParameterfv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafePointer<GLfloat>!)"))
        add(function(name: "glPointSize",
                     paramsSignature: "(_ size: GLfloat)"))
        add(function(name: "glPolygonOffset",
                     paramsSignature: "(_ factor: GLfloat, _ units: GLfloat)"))
        add(function(name: "glRotatef",
                     paramsSignature: "(_ angle: GLfloat, _ x: GLfloat, _ y: GLfloat, _ z: GLfloat)"))
        add(function(name: "glSampleCoverage",
                     paramsSignature: "(_ value: GLclampf, _ invert: GLboolean)"))
        add(function(name: "glScalef",
                     paramsSignature: "(_ x: GLfloat, _ y: GLfloat, _ z: GLfloat)"))
        add(function(name: "glTexEnvf",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ param: GLfloat)"))
        add(function(name: "glTexEnvfv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLfloat>!)"))
        add(function(name: "glTexParameterf",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ param: GLfloat)"))
        add(function(name: "glTexParameterfv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLfloat>!)"))
        add(function(name: "glTranslatef",
                     paramsSignature: "(_ x: GLfloat, _ y: GLfloat, _ z: GLfloat)"))
        add(function(name: "glActiveTexture",
                     paramsSignature: "(_ texture: GLenum)"))
        add(function(name: "glAlphaFuncx",
                     paramsSignature: "(_ func: GLenum, _ ref: GLclampx)"))
        add(function(name: "glBindBuffer",
                     paramsSignature: "(_ target: GLenum, _ buffer: GLuint)"))
        add(function(name: "glBindTexture",
                     paramsSignature: "(_ target: GLenum, _ texture: GLuint)"))
        add(function(name: "glBlendFunc",
                     paramsSignature: "(_ sfactor: GLenum, _ dfactor: GLenum)"))
        add(function(name: "glBufferData",
                     paramsSignature: "(_ target: GLenum, _ size: GLsizeiptr, _ data: UnsafeRawPointer!, _ usage: GLenum)"))
        add(function(name: "glBufferSubData",
                     paramsSignature: "(_ target: GLenum, _ offset: GLintptr, _ size: GLsizeiptr, _ data: UnsafeRawPointer!)"))
        add(function(name: "glClear",
                     paramsSignature: "(_ mask: GLbitfield)"))
        add(function(name: "glClearColorx",
                     paramsSignature: "(_ red: GLclampx, _ green: GLclampx, _ blue: GLclampx, _ alpha: GLclampx)"))
        add(function(name: "glClearDepthx",
                     paramsSignature: "(_ depth: GLclampx)"))
        add(function(name: "glClearStencil",
                     paramsSignature: "(_ s: GLint)"))
        add(function(name: "glClientActiveTexture",
                     paramsSignature: "(_ texture: GLenum)"))
        add(function(name: "glClipPlanex",
                     paramsSignature: "(_ plane: GLenum, _ equation: UnsafePointer<GLfixed>!)"))
        add(function(name: "glColor4ub",
                     paramsSignature: "(_ red: GLubyte, _ green: GLubyte, _ blue: GLubyte, _ alpha: GLubyte)"))
        add(function(name: "glColor4x",
                     paramsSignature: "(_ red: GLfixed, _ green: GLfixed, _ blue: GLfixed, _ alpha: GLfixed)"))
        add(function(name: "glColorMask",
                     paramsSignature: "(_ red: GLboolean, _ green: GLboolean, _ blue: GLboolean, _ alpha: GLboolean)"))
        add(function(name: "glColorPointer",
                     paramsSignature: "(_ size: GLint, _ type: GLenum, _ stride: GLsizei, _ pointer: UnsafeRawPointer!)"))
        add(function(name: "glCompressedTexImage2D",
                     paramsSignature: "(_ target: GLenum, _ level: GLint, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei, _ border: GLint, _ imageSize: GLsizei, _ data: UnsafeRawPointer!)"))
        add(function(name: "glCompressedTexSubImage2D",
                     paramsSignature: "(_ target: GLenum, _ level: GLint, _ xoffset: GLint, _ yoffset: GLint, _ width: GLsizei, _ height: GLsizei, _ format: GLenum, _ imageSize: GLsizei, _ data: UnsafeRawPointer!)"))
        add(function(name: "glCopyTexImage2D",
                     paramsSignature: "(_ target: GLenum, _ level: GLint, _ internalformat: GLenum, _ x: GLint, _ y: GLint, _ width: GLsizei, _ height: GLsizei, _ border: GLint)"))
        add(function(name: "glCopyTexSubImage2D",
                     paramsSignature: "(_ target: GLenum, _ level: GLint, _ xoffset: GLint, _ yoffset: GLint, _ x: GLint, _ y: GLint, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glCullFace",
                     paramsSignature: "(_ mode: GLenum)"))
        add(function(name: "glDeleteBuffers",
                     paramsSignature: "(_ n: GLsizei, _ buffers: UnsafePointer<GLuint>!)"))
        add(function(name: "glDeleteTextures",
                     paramsSignature: "(_ n: GLsizei, _ textures: UnsafePointer<GLuint>!)"))
        add(function(name: "glDepthFunc",
                     paramsSignature: "(_ func: GLenum)"))
        add(function(name: "glDepthMask",
                     paramsSignature: "(_ flag: GLboolean)"))
        add(function(name: "glDepthRangex",
                     paramsSignature: "(_ zNear: GLclampx, _ zFar: GLclampx)"))
        add(function(name: "glDisable",
                     paramsSignature: "(_ cap: GLenum)"))
        add(function(name: "glDisableClientState",
                     paramsSignature: "(_ array: GLenum)"))
        add(function(name: "glDrawArrays",
                     paramsSignature: "(_ mode: GLenum, _ first: GLint, _ count: GLsizei)"))
        add(function(name: "glDrawElements",
                     paramsSignature: "(_ mode: GLenum, _ count: GLsizei, _ type: GLenum, _ indices: UnsafeRawPointer!)"))
        add(function(name: "glEnable",
                     paramsSignature: "(_ cap: GLenum)"))
        add(function(name: "glEnableClientState",
                     paramsSignature: "(_ array: GLenum)"))
        add(function(name: "glFinish",
                     paramsSignature: "()"))
        add(function(name: "glFlush",
                     paramsSignature: "()"))
        add(function(name: "glFogx",
                     paramsSignature: "(_ pname: GLenum, _ param: GLfixed)"))
        add(function(name: "glFogxv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafePointer<GLfixed>!)"))
        add(function(name: "glFrontFace",
                     paramsSignature: "(_ mode: GLenum)"))
        add(function(name: "glFrustumx",
                     paramsSignature: "(_ left: GLfixed, _ right: GLfixed, _ bottom: GLfixed, _ top: GLfixed, _ zNear: GLfixed, _ zFar: GLfixed)"))
        add(function(name: "glGenBuffers",
                     paramsSignature: "(_ n: GLsizei, _ buffers: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glGenTextures",
                     paramsSignature: "(_ n: GLsizei, _ textures: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glGetBooleanv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafeMutablePointer<GLboolean>!)"))
        add(function(name: "glGetBufferParameteriv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetClipPlanex",
                     paramsSignature: "(_ pname: GLenum, _ eqn: UnsafeMutablePointer<GLfixed>!)"))
        add(function(name: "glGetError",
                     paramsSignature: "()",
                     returnType: .typeName("GLenum")))
        add(function(name: "glGetFixedv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafeMutablePointer<GLfixed>!)"))
        add(function(name: "glGetIntegerv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetLightxv",
                     paramsSignature: "(_ light: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfixed>!)"))
        add(function(name: "glGetMaterialxv",
                     paramsSignature: "(_ face: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfixed>!)"))
        add(function(name: "glGetPointerv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafeMutablePointer<UnsafeMutableRawPointer?>!)"))
        add(function(name: "glGetString",
                     paramsSignature: "(_ name: GLenum)",
                     returnType: .typeName("UnsafePointer<GLubyte>!")))
        add(function(name: "glGetTexEnviv",
                     paramsSignature: "(_ env: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetTexEnvxv",
                     paramsSignature: "(_ env: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfixed>!)"))
        add(function(name: "glGetTexParameteriv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetTexParameterxv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfixed>!)"))
        add(function(name: "glHint",
                     paramsSignature: "(_ target: GLenum, _ mode: GLenum)"))
        add(function(name: "glIsBuffer",
                     paramsSignature: "(_ buffer: GLuint)",
                     returnType: .typeName("GLboolean")))
        add(function(name: "glIsEnabled",
                     paramsSignature: "(_ cap: GLenum)",
                     returnType: .typeName("GLboolean")))
        add(function(name: "glIsTexture",
                     paramsSignature: "(_ texture: GLuint)",
                     returnType: .typeName("GLboolean")))
        add(function(name: "glLightModelx",
                     paramsSignature: "(_ pname: GLenum, _ param: GLfixed)"))
        add(function(name: "glLightModelxv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafePointer<GLfixed>!)"))
        add(function(name: "glLightx",
                     paramsSignature: "(_ light: GLenum, _ pname: GLenum, _ param: GLfixed)"))
        add(function(name: "glLightxv",
                     paramsSignature: "(_ light: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLfixed>!)"))
        add(function(name: "glLineWidthx",
                     paramsSignature: "(_ width: GLfixed)"))
        add(function(name: "glLoadIdentity",
                     paramsSignature: "()"))
        add(function(name: "glLoadMatrixx",
                     paramsSignature: "(_ m: UnsafePointer<GLfixed>!)"))
        add(function(name: "glLogicOp",
                     paramsSignature: "(_ opcode: GLenum)"))
        add(function(name: "glMaterialx",
                     paramsSignature: "(_ face: GLenum, _ pname: GLenum, _ param: GLfixed)"))
        add(function(name: "glMaterialxv",
                     paramsSignature: "(_ face: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLfixed>!)"))
        add(function(name: "glMatrixMode",
                     paramsSignature: "(_ mode: GLenum)"))
        add(function(name: "glMultMatrixx",
                     paramsSignature: "(_ m: UnsafePointer<GLfixed>!)"))
        add(function(name: "glMultiTexCoord4x",
                     paramsSignature: "(_ target: GLenum, _ s: GLfixed, _ t: GLfixed, _ r: GLfixed, _ q: GLfixed)"))
        add(function(name: "glNormal3x",
                     paramsSignature: "(_ nx: GLfixed, _ ny: GLfixed, _ nz: GLfixed)"))
        add(function(name: "glNormalPointer",
                     paramsSignature: "(_ type: GLenum, _ stride: GLsizei, _ pointer: UnsafeRawPointer!)"))
        add(function(name: "glOrthox",
                     paramsSignature: "(_ left: GLfixed, _ right: GLfixed, _ bottom: GLfixed, _ top: GLfixed, _ zNear: GLfixed, _ zFar: GLfixed)"))
        add(function(name: "glPixelStorei",
                     paramsSignature: "(_ pname: GLenum, _ param: GLint)"))
        add(function(name: "glPointParameterx",
                     paramsSignature: "(_ pname: GLenum, _ param: GLfixed)"))
        add(function(name: "glPointParameterxv",
                     paramsSignature: "(_ pname: GLenum, _ params: UnsafePointer<GLfixed>!)"))
        add(function(name: "glPointSizex",
                     paramsSignature: "(_ size: GLfixed)"))
        add(function(name: "glPolygonOffsetx",
                     paramsSignature: "(_ factor: GLfixed, _ units: GLfixed)"))
        add(function(name: "glPopMatrix",
                     paramsSignature: "()"))
        add(function(name: "glPushMatrix",
                     paramsSignature: "()"))
        add(function(name: "glReadPixels",
                     paramsSignature: "(_ x: GLint, _ y: GLint, _ width: GLsizei, _ height: GLsizei, _ format: GLenum, _ type: GLenum, _ pixels: UnsafeMutableRawPointer!)"))
        add(function(name: "glRotatex",
                     paramsSignature: "(_ angle: GLfixed, _ x: GLfixed, _ y: GLfixed, _ z: GLfixed)"))
        add(function(name: "glSampleCoveragex",
                     paramsSignature: "(_ value: GLclampx, _ invert: GLboolean)"))
        add(function(name: "glScalex",
                     paramsSignature: "(_ x: GLfixed, _ y: GLfixed, _ z: GLfixed)"))
        add(function(name: "glScissor",
                     paramsSignature: "(_ x: GLint, _ y: GLint, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glShadeModel",
                     paramsSignature: "(_ mode: GLenum)"))
        add(function(name: "glStencilFunc",
                     paramsSignature: "(_ func: GLenum, _ ref: GLint, _ mask: GLuint)"))
        add(function(name: "glStencilMask",
                     paramsSignature: "(_ mask: GLuint)"))
        add(function(name: "glStencilOp",
                     paramsSignature: "(_ fail: GLenum, _ zfail: GLenum, _ zpass: GLenum)"))
        add(function(name: "glTexCoordPointer",
                     paramsSignature: "(_ size: GLint, _ type: GLenum, _ stride: GLsizei, _ pointer: UnsafeRawPointer!)"))
        add(function(name: "glTexEnvi",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ param: GLint)"))
        add(function(name: "glTexEnvx",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ param: GLfixed)"))
        add(function(name: "glTexEnviv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLint>!)"))
        add(function(name: "glTexEnvxv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLfixed>!)"))
        add(function(name: "glTexImage2D",
                     paramsSignature: "(_ target: GLenum, _ level: GLint, _ internalformat: GLint, _ width: GLsizei, _ height: GLsizei, _ border: GLint, _ format: GLenum, _ type: GLenum, _ pixels: UnsafeRawPointer!)"))
        add(function(name: "glTexParameteri",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ param: GLint)"))
        add(function(name: "glTexParameterx",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ param: GLfixed)"))
        add(function(name: "glTexParameteriv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLint>!)"))
        add(function(name: "glTexParameterxv",
                     paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafePointer<GLfixed>!)"))
        add(function(name: "glTexSubImage2D",
                     paramsSignature: "(_ target: GLenum, _ level: GLint, _ xoffset: GLint, _ yoffset: GLint, _ width: GLsizei, _ height: GLsizei, _ format: GLenum, _ type: GLenum, _ pixels: UnsafeRawPointer!)"))
        add(function(name: "glTranslatex",
                     paramsSignature: "(_ x: GLfixed, _ y: GLfixed, _ z: GLfixed)"))
        add(function(name: "glVertexPointer",
                     paramsSignature: "(_ size: GLint, _ type: GLenum, _ stride: GLsizei, _ pointer: UnsafeRawPointer!)"))
        add(function(name: "glViewport",
                     paramsSignature: "(_ x: GLint, _ y: GLint, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glCurrentPaletteMatrixOES",
                     paramsSignature: "(_ matrixpaletteindex: GLuint)"))
        add(function(name: "glLoadPaletteFromModelViewMatrixOES",
                     paramsSignature: "()"))
        add(function(name: "glMatrixIndexPointerOES",
                     paramsSignature: "(_ size: GLint, _ type: GLenum, _ stride: GLsizei, _ pointer: UnsafeRawPointer!)"))
        add(function(name: "glWeightPointerOES",
                     paramsSignature: "(_ size: GLint, _ type: GLenum, _ stride: GLsizei, _ pointer: UnsafeRawPointer!)"))
        add(function(name: "glPointSizePointerOES",
                     paramsSignature: "(_ type: GLenum, _ stride: GLsizei, _ pointer: UnsafeRawPointer!)"))
        add(function(name: "glDrawTexsOES",
                     paramsSignature: "(_ x: GLshort, _ y: GLshort, _ z: GLshort, _ width: GLshort, _ height: GLshort)"))
        add(function(name: "glDrawTexiOES",
                     paramsSignature: "(_ x: GLint, _ y: GLint, _ z: GLint, _ width: GLint, _ height: GLint)"))
        add(function(name: "glDrawTexxOES",
                     paramsSignature: "(_ x: GLfixed, _ y: GLfixed, _ z: GLfixed, _ width: GLfixed, _ height: GLfixed)"))
        add(function(name: "glDrawTexsvOES",
                     paramsSignature: "(_ coords: UnsafePointer<GLshort>!)"))
        add(function(name: "glDrawTexivOES",
                     paramsSignature: "(_ coords: UnsafePointer<GLint>!)"))
        add(function(name: "glDrawTexxvOES",
                     paramsSignature: "(_ coords: UnsafePointer<GLfixed>!)"))
        add(function(name: "glDrawTexfOES",
                     paramsSignature: "(_ x: GLfloat, _ y: GLfloat, _ z: GLfloat, _ width: GLfloat, _ height: GLfloat)"))
        add(function(name: "glDrawTexfvOES",
                     paramsSignature: "(_ coords: UnsafePointer<GLfloat>!)"))
    }
    
    func createES3Functions() {
        add(function(name: "glAttachShader",
                    paramsSignature: "(_ program: GLuint, _ shader: GLuint)"))
        add(function(name: "glBindAttribLocation",
                    paramsSignature: "(_ program: GLuint, _ index: GLuint, _ name: UnsafePointer<GLchar>!)"))
        add(function(name: "glBindFramebuffer",
                    paramsSignature: "(_ target: GLenum, _ framebuffer: GLuint)"))
        add(function(name: "glBindRenderbuffer",
                    paramsSignature: "(_ target: GLenum, _ renderbuffer: GLuint)"))
        add(function(name: "glBlendColor",
                    paramsSignature: "(_ red: GLfloat, _ green: GLfloat, _ blue: GLfloat, _ alpha: GLfloat)"))
        add(function(name: "glBlendEquation",
                    paramsSignature: "(_ mode: GLenum)"))
        add(function(name: "glBlendEquationSeparate",
                    paramsSignature: "(_ modeRGB: GLenum, _ modeAlpha: GLenum)"))
        add(function(name: "glBlendFuncSeparate",
                    paramsSignature: "(_ srcRGB: GLenum, _ dstRGB: GLenum, _ srcAlpha: GLenum, _ dstAlpha: GLenum)"))
        add(function(name: "glCheckFramebufferStatus",
                    paramsSignature: "(_ target: GLenum)",
                    returnType: .typeName("GLenum")))
        add(function(name: "glCompileShader",
                    paramsSignature: "(_ shader: GLuint)"))
        add(function(name: "glCreateProgram",
                    paramsSignature: "()",
                    returnType: .typeName("GLuint")))
        add(function(name: "glCreateShader",
                    paramsSignature: "(_ type: GLenum)",
                    returnType: .typeName("GLuint")))
        add(function(name: "glDeleteFramebuffers",
                    paramsSignature: "(_ n: GLsizei, _ framebuffers: UnsafePointer<GLuint>!)"))
        add(function(name: "glDeleteProgram",
                    paramsSignature: "(_ program: GLuint)"))
        add(function(name: "glDeleteRenderbuffers",
                    paramsSignature: "(_ n: GLsizei, _ renderbuffers: UnsafePointer<GLuint>!)"))
        add(function(name: "glDeleteShader",
                    paramsSignature: "(_ shader: GLuint)"))
        add(function(name: "glDetachShader",
                    paramsSignature: "(_ program: GLuint, _ shader: GLuint)"))
        add(function(name: "glDisableVertexAttribArray",
                    paramsSignature: "(_ index: GLuint)"))
        add(function(name: "glEnableVertexAttribArray",
                    paramsSignature: "(_ index: GLuint)"))
        add(function(name: "glFramebufferRenderbuffer",
                    paramsSignature: "(_ target: GLenum, _ attachment: GLenum, _ renderbuffertarget: GLenum, _ renderbuffer: GLuint)"))
        add(function(name: "glFramebufferTexture2D",
                    paramsSignature: "(_ target: GLenum, _ attachment: GLenum, _ textarget: GLenum, _ texture: GLuint, _ level: GLint)"))
        add(function(name: "glGenerateMipmap",
                    paramsSignature: "(_ target: GLenum)"))
        add(function(name: "glGenFramebuffers",
                    paramsSignature: "(_ n: GLsizei, _ framebuffers: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glGenRenderbuffers",
                    paramsSignature: "(_ n: GLsizei, _ renderbuffers: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glGetActiveAttrib",
                    paramsSignature: "(_ program: GLuint, _ index: GLuint, _ bufsize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ size: UnsafeMutablePointer<GLint>!, _ type: UnsafeMutablePointer<GLenum>!, _ name: UnsafeMutablePointer<GLchar>!)"))
        add(function(name: "glGetActiveUniform",
                    paramsSignature: "(_ program: GLuint, _ index: GLuint, _ bufsize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ size: UnsafeMutablePointer<GLint>!, _ type: UnsafeMutablePointer<GLenum>!, _ name: UnsafeMutablePointer<GLchar>!)"))
        add(function(name: "glGetAttachedShaders",
                    paramsSignature: "(_ program: GLuint, _ maxcount: GLsizei, _ count: UnsafeMutablePointer<GLsizei>!, _ shaders: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glGetAttribLocation",
                    paramsSignature: "(_ program: GLuint, _ name: UnsafePointer<GLchar>!)",
                    returnType: .typeName("Int32")))
        add(function(name: "glGetFramebufferAttachmentParameteriv",
                    paramsSignature: "(_ target: GLenum, _ attachment: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetProgramiv",
                    paramsSignature: "(_ program: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetProgramInfoLog",
                    paramsSignature: "(_ program: GLuint, _ bufsize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ infolog: UnsafeMutablePointer<GLchar>!)"))
        add(function(name: "glGetRenderbufferParameteriv",
                    paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetShaderiv",
                    paramsSignature: "(_ shader: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetShaderInfoLog",
                    paramsSignature: "(_ shader: GLuint, _ bufsize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ infolog: UnsafeMutablePointer<GLchar>!)"))
        add(function(name: "glGetShaderPrecisionFormat",
                    paramsSignature: "(_ shadertype: GLenum, _ precisiontype: GLenum, _ range: UnsafeMutablePointer<GLint>!, _ precision: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetShaderSource",
                    paramsSignature: "(_ shader: GLuint, _ bufsize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ source: UnsafeMutablePointer<GLchar>!)"))
        add(function(name: "glGetUniformfv",
                    paramsSignature: "(_ program: GLuint, _ location: GLint, _ params: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glGetUniformiv",
                    paramsSignature: "(_ program: GLuint, _ location: GLint, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetUniformLocation",
                    paramsSignature: "(_ program: GLuint, _ name: UnsafePointer<GLchar>!)",
                    returnType: .typeName("Int32")))
        add(function(name: "glGetVertexAttribfv",
                    paramsSignature: "(_ index: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glGetVertexAttribiv",
                    paramsSignature: "(_ index: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetVertexAttribPointerv",
                    paramsSignature: "(_ index: GLuint, _ pname: GLenum, _ pointer: UnsafeMutablePointer<UnsafeMutableRawPointer?>!)"))
        add(function(name: "glIsFramebuffer",
                    paramsSignature: "(_ framebuffer: GLuint)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glIsProgram",
                    paramsSignature: "(_ program: GLuint)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glIsRenderbuffer",
                    paramsSignature: "(_ renderbuffer: GLuint)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glIsShader",
                    paramsSignature: "(_ shader: GLuint)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glLinkProgram",
                    paramsSignature: "(_ program: GLuint)"))
        add(function(name: "glReleaseShaderCompiler",
                    paramsSignature: "()"))
        add(function(name: "glRenderbufferStorage",
                    paramsSignature: "(_ target: GLenum, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glShaderBinary",
                    paramsSignature: "(_ n: GLsizei, _ shaders: UnsafePointer<GLuint>!, _ binaryformat: GLenum, _ binary: UnsafeRawPointer!, _ length: GLsizei)"))
        add(function(name: "glShaderSource",
                    paramsSignature: "(_ shader: GLuint, _ count: GLsizei, _ string: UnsafePointer<UnsafePointer<GLchar>?>!, _ length: UnsafePointer<GLint>!)"))
        add(function(name: "glStencilFuncSeparate",
                    paramsSignature: "(_ face: GLenum, _ func: GLenum, _ ref: GLint, _ mask: GLuint)"))
        add(function(name: "glStencilMaskSeparate",
                    paramsSignature: "(_ face: GLenum, _ mask: GLuint)"))
        add(function(name: "glStencilOpSeparate",
                    paramsSignature: "(_ face: GLenum, _ fail: GLenum, _ zfail: GLenum, _ zpass: GLenum)"))
        add(function(name: "glUniform1f",
                    paramsSignature: "(_ location: GLint, _ x: GLfloat)"))
        add(function(name: "glUniform1fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ v: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniform1i",
                    paramsSignature: "(_ location: GLint, _ x: GLint)"))
        add(function(name: "glUniform1iv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ v: UnsafePointer<GLint>!)"))
        add(function(name: "glUniform2f",
                    paramsSignature: "(_ location: GLint, _ x: GLfloat, _ y: GLfloat)"))
        add(function(name: "glUniform2fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ v: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniform2i",
                    paramsSignature: "(_ location: GLint, _ x: GLint, _ y: GLint)"))
        add(function(name: "glUniform2iv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ v: UnsafePointer<GLint>!)"))
        add(function(name: "glUniform3f",
                    paramsSignature: "(_ location: GLint, _ x: GLfloat, _ y: GLfloat, _ z: GLfloat)"))
        add(function(name: "glUniform3fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ v: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniform3i",
                    paramsSignature: "(_ location: GLint, _ x: GLint, _ y: GLint, _ z: GLint)"))
        add(function(name: "glUniform3iv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ v: UnsafePointer<GLint>!)"))
        add(function(name: "glUniform4f",
                    paramsSignature: "(_ location: GLint, _ x: GLfloat, _ y: GLfloat, _ z: GLfloat, _ w: GLfloat)"))
        add(function(name: "glUniform4fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ v: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniform4i",
                    paramsSignature: "(_ location: GLint, _ x: GLint, _ y: GLint, _ z: GLint, _ w: GLint)"))
        add(function(name: "glUniform4iv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ v: UnsafePointer<GLint>!)"))
        add(function(name: "glUniformMatrix2fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniformMatrix3fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniformMatrix4fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUseProgram",
                    paramsSignature: "(_ program: GLuint)"))
        add(function(name: "glValidateProgram",
                    paramsSignature: "(_ program: GLuint)"))
        add(function(name: "glVertexAttrib1f",
                    paramsSignature: "(_ indx: GLuint, _ x: GLfloat)"))
        add(function(name: "glVertexAttrib1fv",
                    paramsSignature: "(_ indx: GLuint, _ values: UnsafePointer<GLfloat>!)"))
        add(function(name: "glVertexAttrib2f",
                    paramsSignature: "(_ indx: GLuint, _ x: GLfloat, _ y: GLfloat)"))
        add(function(name: "glVertexAttrib2fv",
                    paramsSignature: "(_ indx: GLuint, _ values: UnsafePointer<GLfloat>!)"))
        add(function(name: "glVertexAttrib3f",
                    paramsSignature: "(_ indx: GLuint, _ x: GLfloat, _ y: GLfloat, _ z: GLfloat)"))
        add(function(name: "glVertexAttrib3fv",
                    paramsSignature: "(_ indx: GLuint, _ values: UnsafePointer<GLfloat>!)"))
        add(function(name: "glVertexAttrib4f",
                    paramsSignature: "(_ indx: GLuint, _ x: GLfloat, _ y: GLfloat, _ z: GLfloat, _ w: GLfloat)"))
        add(function(name: "glVertexAttrib4fv",
                    paramsSignature: "(_ indx: GLuint, _ values: UnsafePointer<GLfloat>!)"))
        add(function(name: "glVertexAttribPointer",
                    paramsSignature: "(_ indx: GLuint, _ size: GLint, _ type: GLenum, _ normalized: GLboolean, _ stride: GLsizei, _ ptr: UnsafeRawPointer!)"))
        add(function(name: "glReadBuffer",
                    paramsSignature: "(_ mode: GLenum)"))
        add(function(name: "glDrawRangeElements",
                    paramsSignature: "(_ mode: GLenum, _ start: GLuint, _ end: GLuint, _ count: GLsizei, _ type: GLenum, _ indices: UnsafeRawPointer!)"))
        add(function(name: "glTexImage3D",
                    paramsSignature: "(_ target: GLenum, _ level: GLint, _ internalformat: GLint, _ width: GLsizei, _ height: GLsizei, _ depth: GLsizei, _ border: GLint, _ format: GLenum, _ type: GLenum, _ pixels: UnsafeRawPointer!)"))
        add(function(name: "glTexSubImage3D",
                    paramsSignature: "(_ target: GLenum, _ level: GLint, _ xoffset: GLint, _ yoffset: GLint, _ zoffset: GLint, _ width: GLsizei, _ height: GLsizei, _ depth: GLsizei, _ format: GLenum, _ type: GLenum, _ pixels: UnsafeRawPointer!)"))
        add(function(name: "glCopyTexSubImage3D",
                    paramsSignature: "(_ target: GLenum, _ level: GLint, _ xoffset: GLint, _ yoffset: GLint, _ zoffset: GLint, _ x: GLint, _ y: GLint, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glCompressedTexImage3D",
                    paramsSignature: "(_ target: GLenum, _ level: GLint, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei, _ depth: GLsizei, _ border: GLint, _ imageSize: GLsizei, _ data: UnsafeRawPointer!)"))
        add(function(name: "glCompressedTexSubImage3D",
                    paramsSignature: "(_ target: GLenum, _ level: GLint, _ xoffset: GLint, _ yoffset: GLint, _ zoffset: GLint, _ width: GLsizei, _ height: GLsizei, _ depth: GLsizei, _ format: GLenum, _ imageSize: GLsizei, _ data: UnsafeRawPointer!)"))
        add(function(name: "glGenQueries",
                    paramsSignature: "(_ n: GLsizei, _ ids: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glDeleteQueries",
                    paramsSignature: "(_ n: GLsizei, _ ids: UnsafePointer<GLuint>!)"))
        add(function(name: "glIsQuery",
                    paramsSignature: "(_ id: GLuint)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glBeginQuery",
                    paramsSignature: "(_ target: GLenum, _ id: GLuint)"))
        add(function(name: "glEndQuery",
                    paramsSignature: "(_ target: GLenum)"))
        add(function(name: "glGetQueryiv",
                    paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetQueryObjectuiv",
                    paramsSignature: "(_ id: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glUnmapBuffer",
                    paramsSignature: "(_ target: GLenum)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glGetBufferPointerv",
                    paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<UnsafeMutableRawPointer?>!)"))
        add(function(name: "glDrawBuffers",
                    paramsSignature: "(_ n: GLsizei, _ bufs: UnsafePointer<GLenum>!)"))
        add(function(name: "glUniformMatrix2x3fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniformMatrix3x2fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniformMatrix2x4fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniformMatrix4x2fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniformMatrix3x4fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glUniformMatrix4x3fv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ transpose: GLboolean, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glBlitFramebuffer",
                    paramsSignature: "(_ srcX0: GLint, _ srcY0: GLint, _ srcX1: GLint, _ srcY1: GLint, _ dstX0: GLint, _ dstY0: GLint, _ dstX1: GLint, _ dstY1: GLint, _ mask: GLbitfield, _ filter: GLenum)"))
        add(function(name: "glRenderbufferStorageMultisample",
                    paramsSignature: "(_ target: GLenum, _ samples: GLsizei, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glFramebufferTextureLayer",
                    paramsSignature: "(_ target: GLenum, _ attachment: GLenum, _ texture: GLuint, _ level: GLint, _ layer: GLint)"))
        add(function(name: "glMapBufferRange",
                    paramsSignature: "(_ target: GLenum, _ offset: GLintptr, _ length: GLsizeiptr, _ access: GLbitfield)",
                    returnType: .implicitUnwrappedOptional(.typeName("UnsafeMutableRawPointer"))))
        add(function(name: "glFlushMappedBufferRange",
                    paramsSignature: "(_ target: GLenum, _ offset: GLintptr, _ length: GLsizeiptr)"))
        add(function(name: "glBindVertexArray",
                    paramsSignature: "(_ array: GLuint)"))
        add(function(name: "glDeleteVertexArrays",
                    paramsSignature: "(_ n: GLsizei, _ arrays: UnsafePointer<GLuint>!)"))
        add(function(name: "glGenVertexArrays",
                    paramsSignature: "(_ n: GLsizei, _ arrays: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glIsVertexArray",
                    paramsSignature: "(_ array: GLuint)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glGetIntegeri_v",
                    paramsSignature: "(_ target: GLenum, _ index: GLuint, _ data: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glBeginTransformFeedback",
                    paramsSignature: "(_ primitiveMode: GLenum)"))
        add(function(name: "glEndTransformFeedback",
                    paramsSignature: "()"))
        add(function(name: "glBindBufferRange",
                    paramsSignature: "(_ target: GLenum, _ index: GLuint, _ buffer: GLuint, _ offset: GLintptr, _ size: GLsizeiptr)"))
        add(function(name: "glBindBufferBase",
                    paramsSignature: "(_ target: GLenum, _ index: GLuint, _ buffer: GLuint)"))
        add(function(name: "glTransformFeedbackVaryings",
                    paramsSignature: "(_ program: GLuint, _ count: GLsizei, _ varyings: UnsafePointer<UnsafePointer<GLchar>?>!, _ bufferMode: GLenum)"))
        add(function(name: "glGetTransformFeedbackVarying",
                    paramsSignature: "(_ program: GLuint, _ index: GLuint, _ bufSize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ size: UnsafeMutablePointer<GLsizei>!, _ type: UnsafeMutablePointer<GLenum>!, _ name: UnsafeMutablePointer<GLchar>!)"))
        add(function(name: "glVertexAttribIPointer",
                    paramsSignature: "(_ index: GLuint, _ size: GLint, _ type: GLenum, _ stride: GLsizei, _ pointer: UnsafeRawPointer!)"))
        add(function(name: "glGetVertexAttribIiv",
                    paramsSignature: "(_ index: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetVertexAttribIuiv",
                    paramsSignature: "(_ index: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glVertexAttribI4i",
                    paramsSignature: "(_ index: GLuint, _ x: GLint, _ y: GLint, _ z: GLint, _ w: GLint)"))
        add(function(name: "glVertexAttribI4ui",
                    paramsSignature: "(_ index: GLuint, _ x: GLuint, _ y: GLuint, _ z: GLuint, _ w: GLuint)"))
        add(function(name: "glVertexAttribI4iv",
                    paramsSignature: "(_ index: GLuint, _ v: UnsafePointer<GLint>!)"))
        add(function(name: "glVertexAttribI4uiv",
                    paramsSignature: "(_ index: GLuint, _ v: UnsafePointer<GLuint>!)"))
        add(function(name: "glGetUniformuiv",
                    paramsSignature: "(_ program: GLuint, _ location: GLint, _ params: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glGetFragDataLocation",
                    paramsSignature: "(_ program: GLuint, _ name: UnsafePointer<GLchar>!)",
                    returnType: .typeName("GLint")))
        add(function(name: "glUniform1ui",
                    paramsSignature: "(_ location: GLint, _ v0: GLuint)"))
        add(function(name: "glUniform2ui",
                    paramsSignature: "(_ location: GLint, _ v0: GLuint, _ v1: GLuint)"))
        add(function(name: "glUniform3ui",
                    paramsSignature: "(_ location: GLint, _ v0: GLuint, _ v1: GLuint, _ v2: GLuint)"))
        add(function(name: "glUniform4ui",
                    paramsSignature: "(_ location: GLint, _ v0: GLuint, _ v1: GLuint, _ v2: GLuint, _ v3: GLuint)"))
        add(function(name: "glUniform1uiv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ value: UnsafePointer<GLuint>!)"))
        add(function(name: "glUniform2uiv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ value: UnsafePointer<GLuint>!)"))
        add(function(name: "glUniform3uiv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ value: UnsafePointer<GLuint>!)"))
        add(function(name: "glUniform4uiv",
                    paramsSignature: "(_ location: GLint, _ count: GLsizei, _ value: UnsafePointer<GLuint>!)"))
        add(function(name: "glClearBufferiv",
                    paramsSignature: "(_ buffer: GLenum, _ drawbuffer: GLint, _ value: UnsafePointer<GLint>!)"))
        add(function(name: "glClearBufferuiv",
                    paramsSignature: "(_ buffer: GLenum, _ drawbuffer: GLint, _ value: UnsafePointer<GLuint>!)"))
        add(function(name: "glClearBufferfv",
                    paramsSignature: "(_ buffer: GLenum, _ drawbuffer: GLint, _ value: UnsafePointer<GLfloat>!)"))
        add(function(name: "glClearBufferfi",
                    paramsSignature: "(_ buffer: GLenum, _ drawbuffer: GLint, _ depth: GLfloat, _ stencil: GLint)"))
        add(function(name: "glGetStringi",
                    paramsSignature: "(_ name: GLenum, _ index: GLuint)",
                    returnType: .implicitUnwrappedOptional(.generic("UnsafePointer", parameters: .fromCollection(["GLubyte"])))))
        add(function(name: "glCopyBufferSubData",
                    paramsSignature: "(_ readTarget: GLenum, _ writeTarget: GLenum, _ readOffset: GLintptr, _ writeOffset: GLintptr, _ size: GLsizeiptr)"))
        add(function(name: "glGetUniformIndices",
                    paramsSignature: "(_ program: GLuint, _ uniformCount: GLsizei, _ uniformNames: UnsafePointer<UnsafePointer<GLchar>?>!, _ uniformIndices: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glGetActiveUniformsiv",
                    paramsSignature: "(_ program: GLuint, _ uniformCount: GLsizei, _ uniformIndices: UnsafePointer<GLuint>!, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetUniformBlockIndex",
                    paramsSignature: "(_ program: GLuint, _ uniformBlockName: UnsafePointer<GLchar>!)",
                    returnType: .typeName("GLuint")))
        add(function(name: "glGetActiveUniformBlockiv",
                    paramsSignature: "(_ program: GLuint, _ uniformBlockIndex: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetActiveUniformBlockName",
                    paramsSignature: "(_ program: GLuint, _ uniformBlockIndex: GLuint, _ bufSize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ uniformBlockName: UnsafeMutablePointer<GLchar>!)"))
        add(function(name: "glUniformBlockBinding",
                    paramsSignature: "(_ program: GLuint, _ uniformBlockIndex: GLuint, _ uniformBlockBinding: GLuint)"))
        add(function(name: "glDrawArraysInstanced",
                    paramsSignature: "(_ mode: GLenum, _ first: GLint, _ count: GLsizei, _ instancecount: GLsizei)"))
        add(function(name: "glDrawElementsInstanced",
                    paramsSignature: "(_ mode: GLenum, _ count: GLsizei, _ type: GLenum, _ indices: UnsafeRawPointer!, _ instancecount: GLsizei)"))
        add(function(name: "glFenceSync",
                    paramsSignature: "(_ condition: GLenum, _ flags: GLbitfield)",
                    returnType: .implicitUnwrappedOptional(.typeName("GLsync"))))
        add(function(name: "glIsSync",
                    paramsSignature: "(_ sync: GLsync!)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glDeleteSync",
                    paramsSignature: "(_ sync: GLsync!)"))
        add(function(name: "glClientWaitSync",
                    paramsSignature: "(_ sync: GLsync!, _ flags: GLbitfield, _ timeout: GLuint64)",
                    returnType: .typeName("GLenum")))
        add(function(name: "glWaitSync",
                    paramsSignature: "(_ sync: GLsync!, _ flags: GLbitfield, _ timeout: GLuint64)"))
        add(function(name: "glGetInteger64v",
                    paramsSignature: "(_ pname: GLenum, _ params: UnsafeMutablePointer<GLint64>!)"))
        add(function(name: "glGetSynciv",
                    paramsSignature: "(_ sync: GLsync!, _ pname: GLenum, _ bufSize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ values: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetInteger64i_v",
                    paramsSignature: "(_ target: GLenum, _ index: GLuint, _ data: UnsafeMutablePointer<GLint64>!)"))
        add(function(name: "glGetBufferParameteri64v",
                    paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint64>!)"))
        add(function(name: "glGenSamplers",
                    paramsSignature: "(_ count: GLsizei, _ samplers: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glDeleteSamplers",
                    paramsSignature: "(_ count: GLsizei, _ samplers: UnsafePointer<GLuint>!)"))
        add(function(name: "glIsSampler",
                    paramsSignature: "(_ sampler: GLuint)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glBindSampler",
                    paramsSignature: "(_ unit: GLuint, _ sampler: GLuint)"))
        add(function(name: "glSamplerParameteri",
                    paramsSignature: "(_ sampler: GLuint, _ pname: GLenum, _ param: GLint)"))
        add(function(name: "glSamplerParameteriv",
                    paramsSignature: "(_ sampler: GLuint, _ pname: GLenum, _ param: UnsafePointer<GLint>!)"))
        add(function(name: "glSamplerParameterf",
                    paramsSignature: "(_ sampler: GLuint, _ pname: GLenum, _ param: GLfloat)"))
        add(function(name: "glSamplerParameterfv",
                    paramsSignature: "(_ sampler: GLuint, _ pname: GLenum, _ param: UnsafePointer<GLfloat>!)"))
        add(function(name: "glGetSamplerParameteriv",
                    paramsSignature: "(_ sampler: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGetSamplerParameterfv",
                    paramsSignature: "(_ sampler: GLuint, _ pname: GLenum, _ params: UnsafeMutablePointer<GLfloat>!)"))
        add(function(name: "glVertexAttribDivisor",
                    paramsSignature: "(_ index: GLuint, _ divisor: GLuint)"))
        add(function(name: "glBindTransformFeedback",
                    paramsSignature: "(_ target: GLenum, _ id: GLuint)"))
        add(function(name: "glDeleteTransformFeedbacks",
                    paramsSignature: "(_ n: GLsizei, _ ids: UnsafePointer<GLuint>!)"))
        add(function(name: "glGenTransformFeedbacks",
                    paramsSignature: "(_ n: GLsizei, _ ids: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glIsTransformFeedback",
                    paramsSignature: "(_ id: GLuint)",
                    returnType: .typeName("GLboolean")))
        add(function(name: "glPauseTransformFeedback",
                    paramsSignature: "()"))
        add(function(name: "glResumeTransformFeedback",
                    paramsSignature: "()"))
        add(function(name: "glGetProgramBinary",
                    paramsSignature: "(_ program: GLuint, _ bufSize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ binaryFormat: UnsafeMutablePointer<GLenum>!, _ binary: UnsafeMutableRawPointer!)"))
        add(function(name: "glProgramBinary",
                    paramsSignature: "(_ program: GLuint, _ binaryFormat: GLenum, _ binary: UnsafeRawPointer!, _ length: GLsizei)"))
        add(function(name: "glProgramParameteri",
                    paramsSignature: "(_ program: GLuint, _ pname: GLenum, _ value: GLint)"))
        add(function(name: "glInvalidateFramebuffer",
                    paramsSignature: "(_ target: GLenum, _ numAttachments: GLsizei, _ attachments: UnsafePointer<GLenum>!)"))
        add(function(name: "glInvalidateSubFramebuffer",
                    paramsSignature: "(_ target: GLenum, _ numAttachments: GLsizei, _ attachments: UnsafePointer<GLenum>!, _ x: GLint, _ y: GLint, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glTexStorage2D",
                    paramsSignature: "(_ target: GLenum, _ levels: GLsizei, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glTexStorage3D",
                    paramsSignature: "(_ target: GLenum, _ levels: GLsizei, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei, _ depth: GLsizei)"))
        add(function(name: "glGetInternalformativ",
                    paramsSignature: "(_ target: GLenum, _ internalformat: GLenum, _ pname: GLenum, _ bufSize: GLsizei, _ params: UnsafeMutablePointer<GLint>!)"))
        
        // Extended OpenGLES
        
        add(function(name: "glCopyTextureLevelsAPPLE",
                    paramsSignature: "(_ destinationTexture: GLuint, _ sourceTexture: GLuint, _ sourceBaseLevel: GLint, _ sourceLevelCount: GLsizei)"))
        add(function(name: "glRenderbufferStorageMultisampleAPPLE",
                    paramsSignature: "(_ target: GLenum, _ samples: GLsizei, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glResolveMultisampleFramebufferAPPLE",
                    paramsSignature: "()"))
        add(function(name: "glLabelObjectEXT",
                    paramsSignature: "(_ type: GLenum, _ object: GLuint, _ length: GLsizei, _ label: UnsafePointer<Int8>!)"))
        add(function(name: "glGetObjectLabelEXT",
                    paramsSignature: "(_ type: GLenum, _ object: GLuint, _ bufSize: GLsizei, _ length: UnsafeMutablePointer<GLsizei>!, _ label: UnsafeMutablePointer<Int8>!)"))
        add(function(name: "glInsertEventMarkerEXT",
                    paramsSignature: "(_ length: GLsizei, _ marker: UnsafePointer<Int8>!)"))
        add(function(name: "glPushGroupMarkerEXT",
                    paramsSignature: "(_ length: GLsizei, _ marker: UnsafePointer<Int8>!)"))
        add(function(name: "glPopGroupMarkerEXT",
                    paramsSignature: "()"))
        add(function(name: "glDiscardFramebufferEXT",
                    paramsSignature: "(_ target: GLenum, _ numAttachments: GLsizei, _ attachments: UnsafePointer<GLenum>!)"))
        add(function(name: "glMapBufferRangeEXT",
                    paramsSignature: "(_ target: GLenum, _ offset: GLintptr, _ length: GLsizeiptr, _ access: GLbitfield)",
                    returnType: .implicitUnwrappedOptional("UnsafeMutableRawPointer")))
        add(function(name: "glFlushMappedBufferRangeEXT",
                    paramsSignature: "(_ target: GLenum, _ offset: GLintptr, _ length: GLsizeiptr)"))
        add(function(name: "glTexStorage2DEXT",
                    paramsSignature: "(_ target: GLenum, _ levels: GLsizei, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glBlendEquationSeparateOES",
                    paramsSignature: "(_ modeRGB: GLenum, _ modeAlpha: GLenum)"))
        add(function(name: "glBlendFuncSeparateOES",
                    paramsSignature: "(_ srcRGB: GLenum, _ dstRGB: GLenum, _ srcAlpha: GLenum, _ dstAlpha: GLenum)"))
        add(function(name: "glBlendEquationOES",
                    paramsSignature: "(_ mode: GLenum)"))
        add(function(name: "glIsRenderbufferOES",
                    paramsSignature: "(_ renderbuffer: GLuint)",
                    returnType: "GLboolean"))
        add(function(name: "glBindRenderbufferOES",
                    paramsSignature: "(_ target: GLenum, _ renderbuffer: GLuint)"))
        add(function(name: "glDeleteRenderbuffersOES",
                    paramsSignature: "(_ n: GLsizei, _ renderbuffers: UnsafePointer<GLuint>!)"))
        add(function(name: "glGenRenderbuffersOES",
                    paramsSignature: "(_ n: GLsizei, _ renderbuffers: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glRenderbufferStorageOES",
                    paramsSignature: "(_ target: GLenum, _ internalformat: GLenum, _ width: GLsizei, _ height: GLsizei)"))
        add(function(name: "glGetRenderbufferParameterivOES",
                    paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glIsFramebufferOES",
                    paramsSignature: "(_ framebuffer: GLuint)",
                    returnType: "GLboolean"))
        add(function(name: "glBindFramebufferOES",
                    paramsSignature: "(_ target: GLenum, _ framebuffer: GLuint)"))
        add(function(name: "glDeleteFramebuffersOES",
                    paramsSignature: "(_ n: GLsizei, _ framebuffers: UnsafePointer<GLuint>!)"))
        add(function(name: "glGenFramebuffersOES",
                    paramsSignature: "(_ n: GLsizei, _ framebuffers: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glCheckFramebufferStatusOES",
                    paramsSignature: "(_ target: GLenum)",
                    returnType: "GLenum"))
        add(function(name: "glFramebufferRenderbufferOES",
                    paramsSignature: "(_ target: GLenum, _ attachment: GLenum, _ renderbuffertarget: GLenum, _ renderbuffer: GLuint)"))
        add(function(name: "glFramebufferTexture2DOES",
                    paramsSignature: "(_ target: GLenum, _ attachment: GLenum, _ textarget: GLenum, _ texture: GLuint, _ level: GLint)"))
        add(function(name: "glGetFramebufferAttachmentParameterivOES",
                    paramsSignature: "(_ target: GLenum, _ attachment: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<GLint>!)"))
        add(function(name: "glGenerateMipmapOES",
                    paramsSignature: "(_ target: GLenum)"))
        add(function(name: "glGetBufferPointervOES",
                    paramsSignature: "(_ target: GLenum, _ pname: GLenum, _ params: UnsafeMutablePointer<UnsafeMutableRawPointer?>!)"))
        add(function(name: "glMapBufferOES",
                    paramsSignature: "(_ target: GLenum, _ access: GLenum)",
                    returnType: .implicitUnwrappedOptional("UnsafeMutableRawPointer")))
        add(function(name: "glUnmapBufferOES",
                    paramsSignature: "(_ target: GLenum)",
                    returnType: "GLboolean"))
        add(function(name: "glBindVertexArrayOES",
                    paramsSignature: "(_ array: GLuint)"))
        add(function(name: "glDeleteVertexArraysOES",
                    paramsSignature: "(_ n: GLsizei, _ arrays: UnsafePointer<GLuint>!)"))
        add(function(name: "glGenVertexArraysOES",
                    paramsSignature: "(_ n: GLsizei, _ arrays: UnsafeMutablePointer<GLuint>!)"))
        add(function(name: "glIsVertexArrayOES",
                    paramsSignature: "(_ array: GLuint)",
                    returnType: "GLboolean"))
    }
}
