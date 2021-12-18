DYLIB_PATH="$(xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx/lib_InternalSwiftSyntaxParser.dylib"

echo "Copying SwiftSyntax's dylib from path \"$DYLIB_PATH\"..."

for path in ~/Library/Developer/Xcode/DerivedData/*/Build/Products/Debug/; do
    cp $DYLIB_PATH $path
    echo "Copied file to $path"
done
