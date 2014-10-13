package com.coubr.data.types;

/**
 * Created by sebastian on 06.10.14.
 */
public class LocalBusinessCategory {

    public static final String[] automotiveCategories = {
            "autobodyshop",
            "autodealer",
            "autopartsstore",
            "autorental",
            "autorepair",
            "autowash",
            "gasstation",
            "motorcycledealer",
            "motorcyclerepair"
    };

    public static final String[] emergencyCategories = {
            "firestation",
            "hospital",
            "police"
    };

    public static final String[] entertainmentCategories = {
            "adult",
            "amusement",
            "art",
            "casino",
            "cinema",
            "comedy",
            "nightclub"
    };

    public static final String[] financialCategories = {
            "accounting",
            "atm",
            "bank",
            "insurance"
    };

    public static final String[] foodCategories = {
            "bakery",
            "bar",
            "brewery",
            "cafe",
            "fastfood",
            "ice",
            "restaurant",
            "winery"
    };

    public static final String[] governmentCategories = {
            "postoffice"
    };

    public static final String[] healthCategories = {
            "beauty",
            "spa",
            "hair",
            "healthclub",
            "nail",
            "tattoo"
    };

    public static final String[] homeCategories = {
            "electrician",
            "general",
            "hvac",
            "painter",
            "locksmith",
            "moving",
            "plumber",
            "roofing"
    };

    public static final String[] lodgingCategories = {
            "bb",
            "hostel",
            "hotel",
            "motel"
    };

/*

    "medical":Dentist,DiagnosticLab,Hospital,MedicalClinic,Optician,Pharmacy,Physician,VeterinaryCare;

    "professional":AccountingService,Attorney,Dentist,Electrician,GeneralContractor,HousePainter,Locksmith,
    Notary,Plumber,RoofingContractor;


    "sport":BowlingAlley,ExerciseGym,GolfCourse,HealthClub,PublicSwimmingPool,SkiResort,SportsClub,
    StadiumOrArena,TennisComplex;

    "store":AutoPartsStore,BikeStore,BookStore,ClothingStore,ComputerStore,ConvenienceStore,DepartmentStore,
    ElectronicsStore,Florist,FurnitureStore,
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

    "other":AnimalShelter,ChildCare,DryCleaningOrLaundry,EmploymentAgency,InternetCafe,Library,RadioStation,RealEstateAgent,RecyclingCenter,
    SelfStorage,ShoppingCenter,TelevisionStation,TouristInformationCenter,TravelAgency;

*/


    public static boolean isValid(String type, String category) {
        if (category == null || type == null) {
            // category can be null -> this is ok
            return true;
        }

        if (type.equals("automotive")) {

            for (String currentCategory : automotiveCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("emergency")) {

            for (String currentCategory : emergencyCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("entertainment")) {

            for (String currentCategory : entertainmentCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("financial")) {

            for (String currentCategory : financialCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("food")) {

            for (String currentCategory : foodCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("government")) {

            for (String currentCategory : governmentCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("health")) {

            for (String currentCategory : healthCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("home")) {

            for (String currentCategory : homeCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("lodging")) {

            for (String currentCategory : lodgingCategories) {

                if (currentCategory.equals(category)) {
                    return true;
                }

            }

        } else if (type.equals("medical")) {

        } else if (type.equals("professional")) {

        } else if (type.equals("sport")) {

        } else if (type.equals("store")) {

        } else if (type.equals("other")) {

        }

        return false;

    }


}









