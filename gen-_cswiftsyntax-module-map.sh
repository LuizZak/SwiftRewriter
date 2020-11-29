MMAP="SwiftRewriter.xcodeproj/GeneratedModuleMap/_CSwiftSyntax/module.modulemap"
ROOT=$(pwd)

rm -r "$MMAP"
touch "$MMAP"

echo "module _CSwiftSyntax {"                                                                   >> "$MMAP"
echo "   umbrella \"$ROOT/.build/checkouts/swift-syntax/Sources/_CSwiftSyntax/include\""     >> "$MMAP"
echo "   export *"                                                                              >> "$MMAP"
echo "}"                                                                                        >> "$MMAP"
