ROOT=$(pwd)
MMAP_FOLDER="SwiftRewriter.xcodeproj/GeneratedModuleMap/_CSwiftSyntax"
MMAP="$MMAP_FOLDER/module.modulemap"

if [[ -e "$MMAP" ]]; then
    rm "$MMAP"
fi
if [[ ! -e "$MMAP_FOLDER" ]]; then
    mkdir -p "$MMAP_FOLDER"
fi

touch "$MMAP"

echo "module _CSwiftSyntax {"                                                                   >> "$MMAP"
echo "   umbrella \"$ROOT/.build/checkouts/swift-syntax/Sources/_CSwiftSyntax/include\""     >> "$MMAP"
echo "   export *"                                                                              >> "$MMAP"
echo "}"                                                                                        >> "$MMAP"
