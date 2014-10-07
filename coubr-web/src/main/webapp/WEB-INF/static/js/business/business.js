var coubrBusiness = angular.module('coubrBusiness', [
    'ngRoute',
    'coubrBusinessControllers',
    'coubrBusinessFilters',
    'coubrBusinessServices'
]);

var coubrBusinessAuth = angular.module('coubrBusinessAuth', [
    'ngRoute',
    'coubrBusinessAuthControllers',
    'coubrBusinessFilters',
    'coubrBusinessServices'
]);


coubrBusiness.config(['$routeProvider',
    function ($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'static/pages/business/index.html'
            }).
            when('/about', {
                templateUrl: 'static/pages/business/about.html'
            }).
            // legal
            when('/imprint', {
                templateUrl: 'static/pages/legal/imprint.html'
            }).
            when('/privacy', {
                templateUrl: 'static/pages/legal/privacy.html'
            }).
            when('/terms', {
                templateUrl: 'static/pages/legal/terms.html'
            }).
            // register
            when('/register', {
                templateUrl: 'static/pages/business/register.html'
            }).
            when('/login', {
                templateUrl: 'static/pages/business/login.html'
            }).
            when('/resetPassword', {
                templateUrl: 'static/pages/business/resetPassword.html'
            }).
            when('/resetPasswordConfirm', {
                templateUrl: 'static/pages/business/resetPasswordConfirm.html'
            }).
            when('/confirmRegistration', {
                templateUrl: 'static/pages/business/confirmRegistration.html'
            }).
            when('/resendConfirmation', {
                templateUrl: 'static/pages/business/resendConfirmation.html'
            }).
            // dashboard
            when('/dashboard', {
                templateUrl: 'static/pages/business/dashboard.html',
                controller: 'BusinessDashboardCtrl'
            }).
            // blog
            when('/blog', {
                templateUrl: 'static/pages/blog/blog.html',
                controller: 'BlogCtrl'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);

coubrBusinessAuth.config(['$routeProvider',
    function ($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'static/pages/business/dashboard.html',
                controller: 'BusinessDashboardCtrl'
            }).
            // stores
            when('/stores', {
                templateUrl: 'static/pages/business/stores.html',
                controller: 'BusinessStoresCtrl'
            }).
            when('/store/:storeId', {
                templateUrl: 'static/pages/business/store.html',
                controller: 'BusinessStoreCtrl'
            }).
            when('/addstore', {
                templateUrl: 'static/pages/business/addStore.html'
            }).
            when('/addstore2', {
                templateUrl: 'static/pages/business/addStore2.html'
            }).
            when('/addstore3', {
                templateUrl: 'static/pages/business/addStore3.html'
            }).
            // coupons
            when('/coupons', {
                templateUrl: 'static/pages/business/coupons.html',
                controller: 'BusinessCouponsCtrl'
            }).
            when('/coupon/:couponId', {
                templateUrl: 'static/pages/business/coupon.html',
                controller: 'BusinessCouponCtrl'
            }).
            when('/addcoupon', {
                templateUrl: 'static/pages/business/addCoupon.html'
            }).
            // account
            when('/account', {
                templateUrl: 'static/pages/business/account.html',
                controller: 'BusinessAccountCtrl'
            }).
            when('/changeEmail', {
                templateUrl: 'static/pages/business/changeEmail.html'
            }).
            when('/changePassword', {
                templateUrl: 'static/pages/business/changePassword.html'
            }).
            when('/changeName', {
                templateUrl: 'static/pages/business/changeName.html'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
