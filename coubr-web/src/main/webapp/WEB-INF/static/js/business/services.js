var coubrBusinessServices = angular.module('coubrBusinessServices', []);

var handleError = function ($scope, data, status) {

    $scope.error = {};

    if (status == 500) {
        // internal server error
        $scope.error.serverError = true;
    } else if (status == 400) {
        // bad request

        if (data.error == 4000) {
            $scope.error.notLoggedIn = true;
        } else if (data.error == 4001) {
            $scope.error.emailNotFound = true;
        } else if (data.error == 4002) {
            $scope.error.passwordNotFound = true;
        } else if (data.error == 4003) {
            $scope.error.codeNotFound = true;
        } else if (data.error == 4004) {
            $scope.error.notConfirmed = true;
        } else if (data.error == 4005) {
            $scope.error.confirmed = true;
        } else if (data.error == 4006) {
            $scope.error.expired = true;
        } else {
            $scope.error.requestError = true;
        }


    } else if (status == 409) {
        // conflict

        if (data.error == 4091) {
            $scope.error.emailFound = true;
        } else {
            $scope.error.conflictError = true;
        }

    } else {

        $scope.error.otherError = true;

    }

};

coubrBusinessServices.factory('Authentication', ['$http', '$location', '$window', function ($http, $location, $window) {

    /*
     * Log in
     */

    var login = function (loginData, $scope) {
        $scope.load = true;

        $http({
            method: 'post',
            url: 'business/login.do',
            data: {
                email: loginData.email,
                password: loginData.password
            }
        }).success(function () {

            $window.open('b', '_self');

        }).error(function (data, status, headers, config) {

            $scope.load = false;
            handleError($scope, data, status);

        });

    };

    /*
     * Reset password
     */

    var resetPassword = function (resetPasswordData, $scope) {
        $scope.load = true;

        $http({
            method: 'post',
            url: 'business/resetPassword.do',
            data: {
                email: resetPasswordData.email
            }
        }).success(function () {

            $location.search({email: resetPasswordData.email});
            $location.path("resetPasswordConfirm");

        }).error(function (data, status, headers, config) {

            $scope.load = false;
            handleError($scope, data, status);

        });

    };

    /*
     * Reset password confirm
     */

    var resetPasswordConfirm = function (resetPasswordConfirmData, $scope) {
        $scope.load = true;

        $http({
            method: 'post',
            url: 'business/resetPasswordConfirm.do',
            data: {
                email: resetPasswordConfirmData.email,
                code: resetPasswordConfirmData.code,
                password: resetPasswordConfirmData.password,
                passwordRepeat: resetPasswordConfirmData.passwordRepeat
            }
        }).success(function () {

            $location.path("login");

        }).error(function (data, status, headers, config) {

            $scope.load = false;
            handleError($scope, data, status);

        });

    };

    /*
     * Register
     */

    var register = function (registerData, $scope) {
        $scope.load = true;

        $http({
            method: 'post',
            url: 'business/register.do',
            data: {
                email: registerData.email,
                password: registerData.password,
                passwordRepeat: registerData.passwordRepeat
            }
        }).success(function () {

            $location.search({email: registerData.email});
            $location.path("confirmRegistration");

        }).error(function (data, status, headers, config) {

            $scope.load = false;
            handleError($scope, data, status);

        });
    };

    /*
     * Confirm registration
     */

    var confirmRegistration = function (conformRegistrationData, $scope) {
        $scope.load = true;

        $http({
            method: 'post',
            url: 'business/confirmRegistration.do',
            data: {
                email: conformRegistrationData.email,
                code: conformRegistrationData.code
            }
        }).success(function () {

            $location.path("login");

        }).error(function (data, status, headers, config) {

            $scope.load = false;
            handleError($scope, data, status);

        });
    };

    /*
     * Resend
     */

    var resendConfirmation = function (resendConfirmationData, $scope) {
        $scope.load = true;

        $http({
            method: 'post',
            url: 'business/resendConfirmation.do',
            data: {
                email: resendConfirmationData.email
            }
        }).success(function () {

            $location.search({email: resendConfirmationData.email});
            $location.path("confirmRegistration");

        }).error(function (data, status, headers, config) {

            $scope.load = false;
            handleError($scope, data, status);

        });

    };


    return {
        login: login,
        resetPassword: resetPassword,
        resetPasswordConfirm: resetPasswordConfirm,
        register: register,
        confirmRegistration: confirmRegistration,
        resendConfirmation: resendConfirmation
    }

}]);

/*******************************
 *
 * Store
 *
 *******************************/

coubrBusinessServices.factory('Store', ['$http', '$location', function ($http, $location) {

    var stores = function ($scope) {

        $http({
            method: 'get',
            url: 'b/stores'
        }).success(function (data, status, headers, config) {

            $scope.stores = data;

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    var storesWithDetails = function ($scope) {

        $http({
            method: 'get',
            url: 'b/storesWithDetails'
        }).success(function (data, status, headers, config) {

            $scope.stores = data;

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    var store = function (storeId, $scope) {

        $http({
            method: 'get',
            url: 'b/store/' + storeId
        }).success(function (data, status, headers, config) {

            $scope.store = data;

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    return {
        stores: stores,
        storesWithDetails: storesWithDetails,
        store: store
    }
}]);

/*******************************
 *
 * Coupons
 *
 *******************************/

coubrBusinessServices.factory('Coupon', ['$http', '$location', function ($http, $location) {

    var coupons = function ($scope) {

        $http({
            method: 'get',
            url: 'b/coupons'
        }).success(function (data, status, headers, config) {

            $scope.coupons = data;

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    var couponsWithDetails = function ($scope) {

        $http({
            method: 'get',
            url: 'b/couponsWithDetails'
        }).success(function (data, status, headers, config) {

            $scope.coupons = data;

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    var coupon = function (couponId, $scope) {

        $http({
            method: 'get',
            url: 'b/coupon/' + couponId
        }).success(function (data, status, headers, config) {

            $scope.coupons = data;

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    }

    return {
        coupons: coupons,
        couponsWithDetails: couponsWithDetails,
        coupon: coupon
    }
}]);

coubrBusinessServices.factory('Account', ['$http', '$location', function ($http, $location) {

    var changePassword = function (changePasswordData, $scope) {

        $http({
            method: 'post',
            url: 'b/account/changePassword.do',
            data: {
                password: changePasswordData.password,
                newPassword: changePasswordData.newPassword,
                newPasswordRepeat: changePasswordData.newPasswordRepeat
            }
        }).success(function () {

            $location.path("account");

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    var changeEmail = function (changeEmailData, $scope) {

        $http({
            method: 'post',
            url: 'b/account/changeEmail.do',
            data: {
                newEmail: changeEmailData.newEmail,
                newEmailRepeat: changeEmailData.newEmailRepeat
            }
        }).success(function () {

            $location.path("account");

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    var changeName = function (changeNameData, $scope) {

        $http({
            method: 'post',
            url: 'b/account/changeName.do',
            data: {
                firstName: changeNameData.firstName,
                lastName: changeNameData.lastName
            }
        }).success(function () {

            $location.path("account");

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    var account = function ($scope) {

        $http({
            method: 'get',
            url: 'b/account'
        }).success(function (data, status, headers, config) {

            $scope.account = data;

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    var accountWithCompletionHandler = function ($scope, completionHandler) {

        $http({
            method: 'get',
            url: 'b/account'
        }).success(function (data, status, headers, config) {

            $scope.account = data;
            completionHandler();

        }).error(function (data, status, headers, config) {

            handleError($scope, data, status);

        });

    };

    return {
        changePassword: changePassword,
        changeEmail: changeEmail,
        changeName: changeName,
        account: account,
        accountWithCompletionHandler: accountWithCompletionHandler
    }


}]);