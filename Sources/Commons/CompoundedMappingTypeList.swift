public enum CompoundedMappingTypeList {
    public static func typeList() -> [CompoundedMappingType] {
        return [
            FoundationCompoundTypes.nsCalendar.create(),
            FoundationCompoundTypes.nsArray.create(),
            FoundationCompoundTypes.nsMutableArray.create(),
            FoundationCompoundTypes.nsDateFormatter.create(),
            FoundationCompoundTypes.nsDate.create(),
            FoundationCompoundTypes.nsLocale.create(),
            FoundationCompoundTypes.nsString.create(),
            FoundationCompoundTypes.nsMutableString.create(),
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
