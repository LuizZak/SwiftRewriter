public enum CompoundedMappingTypeList {
    public static func typeList() -> [CompoundedMappingType] {
        [
            FoundationCompoundTypes.nsCalendar.create(),
            FoundationCompoundTypes.nsArray.create(),
            FoundationCompoundTypes.nsMutableArray.create(),
            FoundationCompoundTypes.nsDictionary.create(),
            FoundationCompoundTypes.nsMutableDictionary.create(),
            FoundationCompoundTypes.nsDateFormatter.create(),
            FoundationCompoundTypes.nsDate.create(),
            FoundationCompoundTypes.nsLocale.create(),
            FoundationCompoundTypes.nsString.create(),
            FoundationCompoundTypes.nsMutableString.create(),
            CoreGraphicsCompoundTypes.cgSize.create(),
            CoreGraphicsCompoundTypes.cgPoint.create(),
            CoreGraphicsCompoundTypes.cgRect.create(),
            UIResponderCompoundType.create(),
            UIViewCompoundType.create(),
            UIColorCompoundType.create(),
            UIGestureRecognizerCompoundType.create(),
            UILabelCompoundType.create(),
            UIViewControllerCompoundType.create(),
        ]
    }
}
