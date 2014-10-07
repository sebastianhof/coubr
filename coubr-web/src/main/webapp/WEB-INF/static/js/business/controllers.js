var coubrBusinessControllers = angular.module('coubrBusinessControllers', []);
var coubrBusinessAuthControllers = angular.module('coubrBusinessAuthControllers', []);

coubrBusinessControllers.controller('BlogCtrl', function ($scope) {


});

/*
 * Log in
 */

coubrBusinessControllers.controller('BusinessLoginCtrl', ['$scope', 'Authentication', function ($scope, Authentication) {

    $scope.master = {};

    $scope.login = function (loginData, form) {
        $scope.master = angular.copy(loginData);

        if (form.$invalid) {
            return;
        }

        Authentication.login(loginData, $scope);

    }

    $scope.reset = function () {
        $scope.loginData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (loginData) {
        return angular.equals(loginData, $scope.master);
    };

    $scope.reset();

}]);

/*
 * Reset password
 */

coubrBusinessControllers.controller('BusinessResetPasswordCtrl', ['$scope', 'Authentication', function ($scope, Authentication) {

    $scope.master = {};

    $scope.resetPassword = function (resetPasswordData, form) {
        $scope.master = angular.copy(resetPasswordData);

        if (form.$invalid) {
            return;
        }

        Authentication.resetPassword(resetPasswordData, $scope);


    }

    $scope.reset = function () {
        $scope.resetPasswordData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (resetPasswordData) {
        return angular.equals(resetPasswordData, $scope.master);
    };

    $scope.reset();

}]);

/*
 * Reset password confirm
 */

coubrBusinessControllers.controller('BusinessResetPasswordConfirmCtrl', ['$scope', '$location', 'Authentication', function ($scope, $location, Authentication) {

    $scope.master = {};

    $scope.resetPasswordConfirm = function (resetPasswordConfirmData, form) {
        $scope.master = angular.copy(resetPasswordConfirmData);

        if (form.$invalid) {
            return;
        }

        Authentication.resetPasswordConfirm(resetPasswordConfirmData, $scope);

    }

    $scope.reset = function () {
        $scope.resetPasswordConfirmData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (resetPasswordConfirmData) {
        return angular.equals(resetPasswordConfirmData, $scope.master);
    };

    $scope.reset();

    $scope.resetPasswordConfirmData.email = $location.$$search.email;
    $scope.resetPasswordConfirmData.code = $location.$$search.code;

}]);

/*
 * Register
 */

coubrBusinessControllers.controller('BusinessRegisterCtrl', ['$scope', 'Authentication', function ($scope, Authentication) {

    $scope.master = {};

    $scope.register = function (registerData, form) {
        $scope.master = angular.copy(registerData);

        if (form.$invalid) {
            return;
        }

        Authentication.register(registerData, $scope);

    }

    $scope.reset = function () {
        $scope.registerData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (registerData) {
        return angular.equals(registerData, $scope.master);
    };

    $scope.reset();

}]);

/*
 * Confirm registration
 */

coubrBusinessControllers.controller('BusinessConfirmRegistrationCtrl', ['$scope', '$location', 'Authentication', function ($scope, $location, Authentication) {

    $scope.master = {};



    $scope.confirmRegistration = function (confirmRegistrationData, form) {
        $scope.master = angular.copy(confirmRegistrationData);

        if (form.$invalid) {
            return;
        }

        Authentication.confirmRegistration(confirmRegistrationData, $scope);

    }

    $scope.reset = function () {
        $scope.confirmRegistrationData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (confirmRegistrationData) {
        return angular.equals(confirmRegistrationData, $scope.master);
    };

    $scope.reset();

    $scope.confirmRegistrationData.email = $location.$$search.email;
    $scope.confirmRegistrationData.code = $location.$$search.code;

}]);

/*
 * Resend confirmation
 */

coubrBusinessControllers.controller('BusinessResendConfirmationCtrl', ['$scope', 'Authentication', function ($scope, Authentication) {

    $scope.master = {};

    $scope.resendConfirmation = function (resendConfirmationData, form) {
        $scope.master = angular.copy(resendConfirmationData);

        if (form.$invalid) {
            return;
        }

        Authentication.resendConfirmation(resendConfirmationData, $scope);

    }

    $scope.reset = function () {
        $scope.resendConfirmationData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (resendConfirmationData) {
        return angular.equals(resendConfirmationData, $scope.master);
    };

    $scope.reset();

}]);


/**********************************************
 * Auth
 *********************************************/

coubrBusinessAuthControllers.controller('BusinessAccountCtrl', ['$scope', 'Account', function ($scope, Account) {

    Account.account($scope);

}]);

coubrBusinessAuthControllers.controller('BusinessChangeEmailCtrl', ['$scope', 'Account', function ($scope, Account) {

    $scope.master = {};

    $scope.changeEmail = function (changeEmailData, form) {
        $scope.master = angular.copy(changeEmailData);

        if (form.$invalid) {
            return;
        }
        Account.changeEmail(changeEmailData, $scope);

    }

    $scope.reset = function () {
        $scope.changeEmailData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (changeEmailData) {
        return angular.equals(changeEmailData, $scope.master);
    };

    $scope.reset();

}]);

coubrBusinessAuthControllers.controller('BusinessChangePasswordCtrl', ['$scope', 'Account', function ($scope, Account) {

    $scope.master = {};

    $scope.changePassword = function (changePasswordData, form) {
        $scope.master = angular.copy(changePasswordData);

        if (form.$invalid) {
            return;
        }

        Account.changePassword(changePasswordData, $scope);

    }

    $scope.reset = function () {
        $scope.changePasswordData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (changePasswordData) {
        return angular.equals(changePasswordData, $scope.master);
    };

    $scope.reset();

}]);

coubrBusinessAuthControllers.controller('BusinessChangeNameCtrl', ['$scope', 'Account', function ($scope, Account) {

    $scope.master = {};

    $scope.changeName = function (changeNameData, form) {
        $scope.master = angular.copy(changeNameData);

        if (form.$invalid) {
            return;
        }

        Account.changeName(changeNameData, $scope);

    }

    $scope.reset = function () {
        $scope.changeNameData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (changeNameData) {
        return angular.equals(changeNameData, $scope.master);
    };

    $scope.reset();

    Account.accountWithCompletionHandler($scope, function () {

        $scope.master.firstName = $scope.account.firstName;
        $scope.master.lastName = $scope.account.lastName;

        $scope.reset();
    });

}]);

coubrBusinessAuthControllers.controller('BusinessAddStoreCtrl', ['$scope', 'Store', function ($scope, Store) {

    $scope.master = {};

    $scope.addStore = function (addStoreData, form) {
        $scope.master = angular.copy(addStoreData);

        if (form.$invalid) {
            return;
        }

        Store.addStore(addStoreData, $scope);

    }

    $scope.reset = function () {
        $scope.addStoreData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (addStoreData) {
        return angular.equals(addStoreData, $scope.master);
    };

    $scope.reset();

}]);

coubrBusinessAuthControllers.controller('BusinessAddStore2Ctrl', ['$scope', 'Store', function ($scope, Store) {

    $scope.master = {};

    $scope.addStore = function (addStoreData, form) {
        $scope.master = angular.copy(addStoreData);

        if (form.$invalid) {
            return;
        }

        Store.addStore(addStoreData, $scope);

    }

    $scope.reset = function () {
        $scope.addStoreData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (addStoreData) {
        return angular.equals(addStoreData, $scope.master);
    };

    $scope.reset();

}]);

coubrBusinessAuthControllers.controller('BusinessAddStore3Ctrl', ['$scope', 'Store', function ($scope, Store) {

    $scope.master = {};

    $scope.addStore = function (addStoreData, form) {
        $scope.master = angular.copy(addStoreData);

        if (form.$invalid) {
            return;
        }

        Store.addStore(addStoreData, $scope);

    }

    $scope.reset = function () {
        $scope.addStoreData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (addStoreData) {
        return angular.equals(addStoreData, $scope.master);
    };

    $scope.reset();

}]);

coubrBusinessAuthControllers.controller('BusinessAddCouponCtrl', ['$scope', 'Coupon', 'Store', function ($scope, Coupon, Store) {

    $scope.master = {};

    $scope.addCoupon = function (addCouponData, form) {
        $scope.master = angular.copy(addCouponData);

        if (form.$invalid) {
            return;
        }

        Coupon.addCoupon(addCouponData, $scope);

    }

    $scope.reset = function () {
        $scope.addCouponData = angular.copy($scope.master);
    };


    $scope.isUnchanged = function (addCouponData) {
        return angular.equals(addCouponData, $scope.master);
    };

    $scope.reset();

    Store.stores($scope);

}]);

coubrBusinessAuthControllers.controller('BusinessDashboardCtrl', ['$scope', 'Store', 'Coupon', function ($scope, Store, Coupon) {

    Store.stores($scope);
    Coupon.coupons($scope);

}]);

coubrBusinessAuthControllers.controller('BusinessStoresCtrl', ['$scope', 'Store', function ($scope, Store) {

    Store.storesWithDetails($scope);


}]);

coubrBusinessAuthControllers.controller('BusinessStoreCtrl', ['$scope', '$routeParams', 'Store', function ($scope, $routeParams, Store) {

    Store.store($routeParams.storeId, $scope);

}]);

coubrBusinessAuthControllers.controller('BusinessCouponsCtrl', ['$scope', 'Coupon', function ($scope, Coupon) {

    Coupon.couponsWithDetails($scope);

}]);

coubrBusinessAuthControllers.controller('BusinessCouponCtrl', ['$scope', '$routeParams', 'Coupon', function ($scope, $routeParams, Coupon) {

    Coupon.coupon($routeParams.couponId, $scope);

}]);

