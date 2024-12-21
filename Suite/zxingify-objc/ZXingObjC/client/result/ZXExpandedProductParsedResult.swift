// Preprocessor directives found in file:
// #import "ZXParsedResult.h"
// #import "ZXExpandedProductParsedResult.h"
let ZX_KILOGRAM: String! = "KG"
let ZX_POUND: String! = "LB"

@objc
class ZXExpandedProductParsedResult: ZXParsedResult {
    private var _rawText: String!
    private var _productID: String!
    private var _sscc: String!
    private var _lotNumber: String!
    private var _productionDate: String!
    private var _packagingDate: String!
    private var _bestBeforeDate: String!
    private var _expirationDate: String!
    private var _weight: String!
    private var _weightType: String!
    private var _weightIncrement: String!
    private var _price: String!
    private var _priceIncrement: String!
    private var _priceCurrency: String!
    private var _uncommonAIs: NSMutableDictionary!
    @objc var rawText: String! {
        return self._rawText
    }
    @objc var productID: String! {
        return self._productID
    }
    @objc var sscc: String! {
        return self._sscc
    }
    @objc var lotNumber: String! {
        return self._lotNumber
    }
    @objc var productionDate: String! {
        return self._productionDate
    }
    @objc var packagingDate: String! {
        return self._packagingDate
    }
    @objc var bestBeforeDate: String! {
        return self._bestBeforeDate
    }
    @objc var expirationDate: String! {
        return self._expirationDate
    }
    @objc var weight: String! {
        return self._weight
    }
    @objc var weightType: String! {
        return self._weightType
    }
    @objc var weightIncrement: String! {
        return self._weightIncrement
    }
    @objc var price: String! {
        return self._price
    }
    @objc var priceIncrement: String! {
        return self._priceIncrement
    }
    @objc var priceCurrency: String! {
        return self._priceCurrency
    }
    @objc var uncommonAIs: NSMutableDictionary! {
        return self._uncommonAIs
    }

    @objc
    override init() {
        return self.init(rawText: "", productID: "", sscc: "", lotNumber: "", productionDate: "", packagingDate: "", bestBeforeDate: "", expirationDate: "", weight: "", weightType: "", weightIncrement: "", price: "", priceIncrement: "", priceCurrency: "", uncommonAIs: NSMutableDictionary())
    }
    @objc
    init(rawText: String!, productID: String!, sscc: String!, lotNumber: String!, productionDate: String!, packagingDate: String!, bestBeforeDate: String!, expirationDate: String!, weight: String!, weightType: String!, weightIncrement: String!, price: String!, priceIncrement: String!, priceCurrency: String!, uncommonAIs: NSMutableDictionary!) {
        if self = super.init(type: ZXParsedResultType.kParsedResultTypeProduct) {
            _rawText = rawText

            _productID = productID

            _sscc = sscc

            _lotNumber = lotNumber

            _productionDate = productionDate

            _packagingDate = packagingDate

            _bestBeforeDate = bestBeforeDate

            _expirationDate = expirationDate

            _weight = weight

            _weightType = weightType

            _weightIncrement = weightIncrement

            _price = price

            _priceIncrement = priceIncrement

            _priceCurrency = priceCurrency

            _uncommonAIs = uncommonAIs
        }

        return self
    }

    @objc
    static func expandedProductParsedResultWithRawText(_ rawText: String!, productID: String!, sscc: String!, lotNumber: String!, productionDate: String!, packagingDate: String!, bestBeforeDate: String!, expirationDate: String!, weight: String!, weightType: String!, weightIncrement: String!, price: String!, priceIncrement: String!, priceCurrency: String!, uncommonAIs: NSMutableDictionary!) -> AnyObject? {
        return self.init(rawText: rawText, productID: productID, sscc: sscc, lotNumber: lotNumber, productionDate: productionDate, packagingDate: packagingDate, bestBeforeDate: bestBeforeDate, expirationDate: expirationDate, weight: weight, weightType: weightType, weightIncrement: weightIncrement, price: price, priceIncrement: priceIncrement, priceCurrency: priceCurrency, uncommonAIs: uncommonAIs)
    }
    @objc
    func isEqual(_ o: AnyObject) -> Bool {
        if !o.isKindOfClass(type(of: self)) {
            return false
        }

        let other = o as? ZXExpandedProductParsedResult

        return self.equalsOrNil(self.productID, o2: other?.productID) && self.equalsOrNil(self.sscc, o2: other?.sscc) && self.equalsOrNil(self.lotNumber, o2: other?.lotNumber) && self.equalsOrNil(self.productionDate, o2: other?.productionDate) && self.equalsOrNil(self.bestBeforeDate, o2: other?.bestBeforeDate) && self.equalsOrNil(self.expirationDate, o2: other?.expirationDate) && self.equalsOrNil(self.weight, o2: other?.weight) && self.equalsOrNil(self.weightType, o2: other?.weightType) && self.equalsOrNil(self.weightIncrement, o2: other?.weightIncrement) && self.equalsOrNil(self.price, o2: other?.price) && self.equalsOrNil(self.priceIncrement, o2: other?.priceIncrement) && self.equalsOrNil(self.priceCurrency, o2: other?.priceCurrency) && self.equalsOrNil(self.uncommonAIs, o2: other?.uncommonAIs)
    }
    @objc
    func equalsOrNil(_ o1: AnyObject!, o2: AnyObject!) -> Bool {
        return (o1 == nil) ? o2 == nil : o1.isEqual(o2)
    }
    @objc
    func hash() -> UInt {
        var hash: CInt = 0

        hash ^= self.productID.hash()
        hash ^= self.sscc.hash()
        hash ^= self.lotNumber.hash()
        hash ^= self.productionDate.hash()
        hash ^= self.bestBeforeDate.hash()
        hash ^= self.expirationDate.hash()
        hash ^= self.weight.hash()
        hash ^= self.weightType.hash()
        hash ^= self.weightIncrement.hash()
        hash ^= self.price.hash()
        hash ^= self.priceIncrement.hash()
        hash ^= self.priceCurrency.hash()
        hash ^= self.uncommonAIs.hash()

        return UInt(hash)
    }
    @objc
    func displayResult() -> String? {
        return self.rawText
    }
}