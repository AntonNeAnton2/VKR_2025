// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let _262845 = ColorAsset(name: "262845")
    internal static let _263158 = ColorAsset(name: "263158")
    internal static let _313F6E = ColorAsset(name: "313F6E")
    internal static let _5872D0 = ColorAsset(name: "5872D0")
    internal static let _738Dea = ColorAsset(name: "738DEA")
    internal static let _8290Be = ColorAsset(name: "8290BE")
    internal static let _89E80F = ColorAsset(name: "89E80F")
    internal static let e1Cabf = ColorAsset(name: "E1CABF")
    internal static let e7Ea73 = ColorAsset(name: "E7EA73")
    internal static let efefef = ColorAsset(name: "EFEFEF")
    internal static let f0C577 = ColorAsset(name: "F0C577")
    internal static let fdffc2 = ColorAsset(name: "FDFFC2")
  }
  internal enum Images {
    internal static let chChoFro = ImageAsset(name: "ch-cho-fro")
    internal static let chComOfRoyNavy = ImageAsset(name: "ch-com-of-roy-navy")
    internal static let chCotCanCloud = ImageAsset(name: "ch-cot-can-cloud")
    internal static let chDiplo = ImageAsset(name: "ch-diplo")
    internal static let chDonkey = ImageAsset(name: "ch-donkey")
    internal static let chDragon = ImageAsset(name: "ch-dragon")
    internal static let chDwarf = ImageAsset(name: "ch-dwarf")
    internal static let chElf = ImageAsset(name: "ch-elf")
    internal static let chGhost = ImageAsset(name: "ch-ghost")
    internal static let chGingy = ImageAsset(name: "ch-gingy")
    internal static let chHen = ImageAsset(name: "ch-hen")
    internal static let chKingNQueen = ImageAsset(name: "ch-king-n-queen")
    internal static let chKitty = ImageAsset(name: "ch-kitty")
    internal static let chKnight = ImageAsset(name: "ch-knight")
    internal static let chMarshmallow = ImageAsset(name: "ch-marshmallow")
    internal static let chMsStrawberry = ImageAsset(name: "ch-ms-strawberry")
    internal static let chOrc = ImageAsset(name: "ch-orc")
    internal static let chParrot = ImageAsset(name: "ch-parrot")
    internal static let chPirCapDaughter = ImageAsset(name: "ch-pir-cap-daughter")
    internal static let chPirateCap = ImageAsset(name: "ch-pirate-cap")
    internal static let chPolly = ImageAsset(name: "ch-polly")
    internal static let chPotionsMaster = ImageAsset(name: "ch-potions-master")
    internal static let chPrince = ImageAsset(name: "ch-prince")
    internal static let chPrincess = ImageAsset(name: "ch-princess")
    internal static let chPtero = ImageAsset(name: "ch-ptero")
    internal static let chPuppy = ImageAsset(name: "ch-puppy")
    internal static let chRexie = ImageAsset(name: "ch-rexie")
    internal static let chSchoolHead = ImageAsset(name: "ch-school-head")
    internal static let chSheep = ImageAsset(name: "ch-sheep")
    internal static let chTricey = ImageAsset(name: "ch-tricey")
    internal static let chWhiteHorse = ImageAsset(name: "ch-white-horse")
    internal static let chWizard = ImageAsset(name: "ch-wizard")
    internal static let chYoungPirate = ImageAsset(name: "ch-young-pirate")
    internal static let chYoungWitch = ImageAsset(name: "ch-young-witch")
    internal static let chYoungWizard = ImageAsset(name: "ch-young-wizard")
    internal static let evAssisTheFarmer = ImageAsset(name: "ev-assis-the-farmer")
    internal static let evBall = ImageAsset(name: "ev-ball")
    internal static let evBroomstickFlight = ImageAsset(name: "ev-broomstick-flight")
    internal static let evBuilGinHouse = ImageAsset(name: "ev-buil-gin-house")
    internal static let evCaptureByTrolls = ImageAsset(name: "ev-capture-by-trolls")
    internal static let evChocRiver = ImageAsset(name: "ev-choc-river")
    internal static let evDarkForest = ImageAsset(name: "ev-dark-forest")
    internal static let evDessertIsl = ImageAsset(name: "ev-dessert-isl")
    internal static let evDuelDarkWiz = ImageAsset(name: "ev-duel-dark-wiz")
    internal static let evElvenRelics = ImageAsset(name: "ev-elven-relics")
    internal static let evGoblinDungeon = ImageAsset(name: "ev-goblin-dungeon")
    internal static let evGreatBattle = ImageAsset(name: "ev-great-battle")
    internal static let evHighTower = ImageAsset(name: "ev-high-tower")
    internal static let evIceAge = ImageAsset(name: "ev-ice-age")
    internal static let evLearningSpells = ImageAsset(name: "ev-learning-spells")
    internal static let evMagForest = ImageAsset(name: "ev-mag-forest")
    internal static let evMeetFairy = ImageAsset(name: "ev-meet-fairy")
    internal static let evNeanderthals = ImageAsset(name: "ev-neanderthals")
    internal static let evNewFruits = ImageAsset(name: "ev-new-fruits")
    internal static let evPiggysBirthday = ImageAsset(name: "ev-piggys-birthday")
    internal static let evPortRaid = ImageAsset(name: "ev-port-raid")
    internal static let evPotionBrewing = ImageAsset(name: "ev-potion-brewing")
    internal static let evRescueTheHarvest = ImageAsset(name: "ev-rescue-the-harvest")
    internal static let evSaveMeltCity = ImageAsset(name: "ev-save-melt-city")
    internal static let evSeaBattle = ImageAsset(name: "ev-sea-battle")
    internal static let evShipwreck = ImageAsset(name: "ev-shipwreck")
    internal static let evSwSodeRain = ImageAsset(name: "ev-sw-sode-rain")
    internal static let evTimeTravel = ImageAsset(name: "ev-time-travel")
    internal static let evTractorRepair = ImageAsset(name: "ev-tractor-repair")
    internal static let evTreasureChest = ImageAsset(name: "ev-treasure-chest")
    internal static let evVisHauntHouse = ImageAsset(name: "ev-vis-haunt-house")
    internal static let evVolcano = ImageAsset(name: "ev-volcano")
    internal static let evWarWithSoKing = ImageAsset(name: "ev-war-with-so-king")
    internal static let evWolfPackAttack = ImageAsset(name: "ev-wolf-pack-attack")
    internal static let evWoodCreatures = ImageAsset(name: "ev-wood-creatures")
    internal static let addButton = ImageAsset(name: "add-button")
    internal static let backButton = ImageAsset(name: "back-button")
    internal static let mainBackground = ImageAsset(name: "main-background")
    internal static let stepBackground = ImageAsset(name: "step-background")
    internal static let blueMagician = ImageAsset(name: "blue-magician")
    internal static let closeButton = ImageAsset(name: "close-button")
    internal static let plusButton = ImageAsset(name: "plus-button")
    internal static let premiumButton = ImageAsset(name: "premium-button")
    internal static let purpleMagician = ImageAsset(name: "purple-magician")
    internal static let removeButtonCircle = ImageAsset(name: "remove-button-circle")
    internal static let saveSelected = ImageAsset(name: "save-selected")
    internal static let saveUnselected = ImageAsset(name: "save-unselected")
    internal static let tabLibrarySelected = ImageAsset(name: "tab-library-selected")
    internal static let tabLibrary = ImageAsset(name: "tab-library")
    internal static let tabMakeStorySelected = ImageAsset(name: "tab-make-story-selected")
    internal static let tabMakeStory = ImageAsset(name: "tab-make-story")
    internal static let tabSettingsSelected = ImageAsset(name: "tab-settings-selected")
    internal static let tabSettings = ImageAsset(name: "tab-settings")
    internal static let whiteStar = ImageAsset(name: "white-star")
    internal static let libraryIconCell = ImageAsset(name: "library-icon-cell")
    internal static let lightBackground = ImageAsset(name: "light-background")
    internal static let progress1 = ImageAsset(name: "progress-1")
    internal static let progress2 = ImageAsset(name: "progress-2")
    internal static let progress3 = ImageAsset(name: "progress-3")
    internal static let progress4 = ImageAsset(name: "progress-4")
    internal static let moAlwBeKind = ImageAsset(name: "mo-alw-be-kind")
    internal static let moBeHonest = ImageAsset(name: "mo-be-honest")
    internal static let moFriendship = ImageAsset(name: "mo-friendship")
    internal static let moIndustr = ImageAsset(name: "mo-industr")
    internal static let moLearnToForg = ImageAsset(name: "mo-learn-to-forg")
    internal static let moModesty = ImageAsset(name: "mo-modesty")
    internal static let moNevGivUp = ImageAsset(name: "mo-nev-giv-up")
    internal static let moRespOthers = ImageAsset(name: "mo-resp-others")
    internal static let moThBeYoAct = ImageAsset(name: "mo-th-be-yo-act")
    internal static let onboardingFirstPageBackgroundIpad = ImageAsset(name: "onboarding-first-page-background-ipad")
    internal static let onboardingFirstPageBackground = ImageAsset(name: "onboarding-first-page-background")
    internal static let onboardingSecondPageBackgroundIpad = ImageAsset(name: "onboarding-second-page-background-ipad")
    internal static let onboardingSecondPageBackground = ImageAsset(name: "onboarding-second-page-background")
    internal static let onboardingThirdPageBackgroundIpad = ImageAsset(name: "onboarding-third-page-background-ipad")
    internal static let onboardingThirdPageBackground = ImageAsset(name: "onboarding-third-page-background")
    internal static let ondoardingStep1 = ImageAsset(name: "ondoarding-step-1")
    internal static let ondoardingStep2 = ImageAsset(name: "ondoarding-step-2")
    internal static let ondoardingStep3 = ImageAsset(name: "ondoarding-step-3")
    internal static let settingsChangeLanguage = ImageAsset(name: "settings-change-language")
    internal static let settingsHelp = ImageAsset(name: "settings-help")
    internal static let settingsLegal = ImageAsset(name: "settings-legal")
    internal static let settingsRateUs = ImageAsset(name: "settings-rate-us")
    internal static let settingsShare = ImageAsset(name: "settings-share")
    internal static let failyWithMagWand = ImageAsset(name: "faily-with-mag-wand")
    internal static let subscriptionBackground = ImageAsset(name: "subscription-background")
    internal static let subscriptionCross = ImageAsset(name: "subscription-cross")
    internal static let subscriptionFairy = ImageAsset(name: "subscription-fairy")
    internal static let subscriptionSmallFairy = ImageAsset(name: "subscription-small-fairy")
    internal static let unAnimalFarm = ImageAsset(name: "un-animal-farm")
    internal static let unCandyLand = ImageAsset(name: "un-candy-land")
    internal static let unDinoIsland = ImageAsset(name: "un-dino-island")
    internal static let unMistwood = ImageAsset(name: "un-mistwood")
    internal static let unPiratesParadise = ImageAsset(name: "un-pirates-paradise")
    internal static let unPrincessCastle = ImageAsset(name: "un-princess-castle")
    internal static let unWizardSchool = ImageAsset(name: "un-wizard-school")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
