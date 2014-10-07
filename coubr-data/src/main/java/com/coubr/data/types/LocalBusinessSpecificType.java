package com.coubr.data.types;



enum AutomotiveBusiness implements LocalBusinessSpecificType {

    AutoBodyShop, AutoDealer, AutoPartsStore, AutoRental, AutoRepair, AutoWash,
    GasStation, MotorcycleDealer, MotorcycleRepair;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.AutomotiveBusiness;
    }

}

enum EmergencyService implements LocalBusinessSpecificType {

    FireStation, Hospital, PoliceStation;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.EmergencyService;
    }

}

enum EntertainmentBusiness implements LocalBusinessSpecificType {

    AdultEntertainment, AmusementPark, ArtGallery, Casino, ComedyClub, MovieTheater, NightClub;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.EntertainmentBusiness;
    }

}

enum FinancialService implements LocalBusinessSpecificType {

    AccountingService, AutomatedTeller, BankOrCreditUnion, InsuranceAngency;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.FinancialService;
    }

}

enum FoodEstablishment implements LocalBusinessSpecificType {

    Bakery, BarOrPub, Brewery, CafeOrCoffeeShop, FastFootRestaurant, IceCreamShop, Restaurant, Winery;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.FoodEstablishment;
    }

}

enum GovernmentOffice implements LocalBusinessSpecificType {

    PostOffice;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.GovernmentOffice;
    }

}

enum HealthAndBeautyBusiness implements LocalBusinessSpecificType {

    BeautySalon, DaySpa, HairSalon, HealthClub, NailSalon, TattooParlor;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.HealthAndBeautyBusiness;
    }

}


enum HomeAndConstructionBusiness implements LocalBusinessSpecificType {

    Electrician, GeneralContractor, HVACBusiness, HousePainter, Locksmith,
    MovingCompany, Plumber, RoofingContractor;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.HomeAndConstructionBusiness;
    }

}


enum LodgingBusiness implements LocalBusinessSpecificType {

    BedAndBreakfast, Hostel, Hotel, Motel;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.LodgingBusiness;
    }

}

enum MedicalOrganization implements LocalBusinessSpecificType {

    Dentist, DiagnosticLab, Hospital, MedicalClinic, Optician, Pharmacy, Physician, VeterinaryCare;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.MedicalOrganization;
    }

}

enum ProfessionalService implements LocalBusinessSpecificType {

    AccountingService, Attorney, Dentist, Electrician, GeneralContractor, HousePainter, Locksmith,
    Notary, Plumber, RoofingContractor;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.ProfessionalService;
    }

}

enum SportsActivityLocation implements LocalBusinessSpecificType {

    BowlingAlley, ExerciseGym, GolfCourse, HealthClub, PublicSwimmingPool, SkiResort, SportsClub,
    StadiumOrArena, TennisComplex;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.SportsActivityLocation;
    }

}

enum Store implements LocalBusinessSpecificType {

    AutoPartsStore,
    BikeStore,
    BookStore,
    ClothingStore,
    ComputerStore,
    ConvenienceStore,
    DepartmentStore,
    ElectronicsStore,
    Florist,
    FurnitureStore,
    GardenStore,
    GroceryStore,
    HardwareStore,
    HobbyShop,
    HomeGoodsStore,
    JewelryStore,
    LiquorStore,
    MensClothingStore,
    MobilePhoneStore,
    MovieRentalStore,
    MusicStore,
    OfficeEquipmentStore,
    OutletStore,
    PawnShop,
    PetStore,
    ShoeStore,
    SportingGoodsStore,
    TireShop,
    ToyStore,
    WholesaleStore;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.Store;
    }
}

enum other implements LocalBusinessSpecificType {

    AnimalShelter, ChildCare, DryCleaningOrLaundry, EmploymentAgency, InternetCafe, Library, RadioStation, RealEstateAgent, RecyclingCenter,
    SelfStorage, ShoppingCenter, TelevisionStation, TouristInformationCenter, TravelAgency;

    @Override
    public LocalBusinessType getLocalBusinessType() {
        return LocalBusinessType.Other;
    }
}

/**
 * Created by sebastian on 06.10.14.
 */
public interface LocalBusinessSpecificType {

    public LocalBusinessType getLocalBusinessType();

}





