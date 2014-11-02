/*
 * coubr-business
 * http://www.coubr.com/labs/coubrUI
 *
 * Version: 0.0.1
 * Copyright 2014. Sebastian Hof
 * License: proprietary
 */
var coubrBusiness = angular.module('coubrBusiness', [
    'ngRoute',
    'coubrJS',
    'ui.bootstrap'
]);

/**********************************************
 **********************************************
 *
 * Store
 *
 **********************************************
 *********************************************/

coubrBusiness.factory('Store', ['Coubr', function (Coubr) {

    /*****************************
     * Store Types
     *****************************/

    var types = function () {

        return [
            {id: 'food', name: 'Food Establishment'}
        ];

    };

    /*****************************
     * Store Categories
     *****************************/

    var categories = function (typeId) {

        if (typeId == 'food') {

            return [
                {id: 'bakery', name: 'Bakery'},
                {id: 'bar', name: 'Bar and Pub'},
                {id: 'brewery', name: 'Brewery'},
                {id: 'cafe', name: 'Cafe'},
                {id: 'fastfood', name: 'Fast Food Restaurant'},
                {id: 'ice', name: 'Ice Cream'},
                {id: 'restaurant', name: 'Restaurant'},
                {id: 'winery', name: 'Winery'}
            ];

        }

    };

    /*****************************
     * Store Subcategories
     *****************************/

    var subcategories = function (categoryId) {

        if (categoryId == 'restaurant') {

            return [
                {id: 'asian', name: 'Asian'},
                {id: 'french', name: 'French'},
                {id: 'german', name: 'German'},
                {id: 'italian', name: 'Italian'}
            ];

        }

    };

    return {
        types: types,
        categories: categories,
        subcategories: subcategories
    }


}]);

coubrBusiness.controller('StoreTypeController', ['$scope', 'Store', function ($scope, Store) {

    $scope.types = Store.types();

    $scope.selectType = function (id) {
        $scope.data.type = id;
        $scope.data.category = null;
        $scope.data.subcategory = null;
        $scope.categories = null;
        $scope.categories = Store.categories(id);
    };

    $scope.selectCategory = function (id) {
        $scope.data.category = id;
        $scope.data.subcategory = null;
        $scope.subcategories = null;
        $scope.subcategories = Store.subcategories(id);
    };

    $scope.selectSubcategory = function (id) {
        $scope.data.subcategory = id;
    };

    $scope.$on('success', function (event, success) {

        if (success.data && success.data.type) {
            $scope.selectType(success.data.type);

            if (success.data.category) {
                $scope.selectCategory(success.data.category);
            }

            if (success.data.subcategory) {
                $scope.selectSubcategory(success.data.subcategory);
            }

        }

    });

}]);


/**********************************************
 **********************************************
 *
 * Coupons
 *
 **********************************************
 *********************************************/

coubrBusiness.factory('Coupon', ['Coubr', function (Coubr) {

    /*****************************
     * Coupon Categories
     *****************************/

    var categories = function (typeId) {

        if (typeId == 'coupon') {

            return [
                {id: 'default', name: 'Default'}
            ];

        }
    };

    return {
        categories: categories
    }

}]);

coubrBusiness.controller('CouponCategoryController', ['$scope', 'Coupon', function ($scope, Coupon) {

    $scope.categories = Coupon.categories('coupon');

    $scope.hasCategories = function () {
        return $scope.categories != null && $scope.categories.length > 0;
    }

    $scope.selectType = function (id) {
        $scope.data.type = id;
        $scope.data.category = null;
        $scope.categories = null;
        $scope.categories = Coupon.categories(id);
    };

    $scope.selectCategory = function (id) {
        $scope.data.category = id;
    };

    $scope.$on('success', function (event, success) {

        if (success.data && success.data.category) {
            $scope.selectCategory(success.data.category);
        }

    });

}]);

coubrBusiness.controller('CouponActivationController', ['$scope', 'Coubr', function ($scope, Coubr) {

    $scope.isActivated = function () {
        return $scope.data.status == 'active';
    }

    $scope.isDeactivated = function () {
        return $scope.data.status == 'inactive';
    }

    $scope.activate = function () {

        Coubr.post(Coubr.transformURI('/b/coupon/:couponId/activate')).then(function (success) {
            $scope.fetch();
        });

    }

    $scope.deactivate = function () {

        Coubr.post(Coubr.transformURI('/b/coupon/:couponId/deactivate')).then(function (success) {
            $scope.fetch();
        });

    }


}]);

coubrBusiness.controller('CouponStoreController', ['$scope', 'Coupon', 'Coubr', function ($scope, Coupon, Coubr) {

    $scope.stores = {};

    if (!$scope.data.stores) {
        $scope.data.stores = [];
    }

    $scope.hasStores = function () {
        // use bind
        return $scope.stores.stores != null && $scope.stores.stores.length > 0;
    }

    $scope.isStoreSelected = function (storeId) {
        return $scope.data.stores.indexOf(storeId) >= 0;
    }

    $scope.selectStore = function (storeId) {
        if ($scope.isStoreSelected(storeId)) {
            var idx = $scope.data.stores.indexOf(storeId);

            $scope.data.stores.splice(idx, 1);
        } else {
            $scope.data.stores.push(storeId);
        }
    };

    $scope.selectAllStores = function () {
        $scope.data.stores = [];

        $scope.stores.stores.forEach(function (store) {
            $scope.data.stores.push(store.storeId);
        });
    };

    $scope.$on('success', function (event, success) {

        if (success.data && success.data.type) {

            $scope.selectType(success.data.type);

            if (success.data.category) {
                $scope.selectCategory(success.data.category);
            }

            if (success.data.subcategory) {
                $scope.selectSubcategory(success.data.subcategory);
            }

        }

    });

    Coubr.get('/b/stores').then(function (success) {

        if (success.data) {

            if (angular.isObject(success.data)) {
                Object.getOwnPropertyNames(success.data).forEach(function (entry) {

                    $scope.stores[entry] = success.data[entry];

                });
            }

        }

    });


}]);

coubrBusiness.controller('CouponValidToDateController', ['$scope', 'Coubr', function ($scope, Coubr) {

    $scope.today = Date.now();

    Coubr.get(Coubr.transformURI('coupon/:couponId/validTo')).then(function (success) {

        $scope.data.validTo = new Date(success.data.validTo);

    });

    // $scope.$on('success', function (event, success) {
    //
    //     if (success.data && success.data.validTo) {
    //         $scope.data.validTo = new Date(success.data.validTo);
    //     }
    //
    // });


}]);




/**********************************************
 **********************************************
 *
 * Feedback (beta)
 *
 **********************************************
 *********************************************/

coubrBusiness.controller('FeedbackController', ['$scope', '$modal', function ($scope, $modal) {

    $scope.open = function (size) {

        var modalInstance = $modal.open({
            templateUrl: '/static/pages/feedback.html',
            controller: 'FeedbackInstanceController',
            size: size
        });

    };

}]);

coubrBusiness.controller('FeedbackInstanceController', ['$scope', '$modalInstance', '$location', '$window', function ($scope, $modalInstance, $location, $window) {

    $scope.data = {};
    $scope.data.location = $location.absUrl();
    $scope.data.userAgent = $window.navigator.userAgent;

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };

}]);

/**********************************************
 **********************************************
 *
 * Google Maps
 *
 **********************************************
 *********************************************/

coubrBusiness.directive('cbrstoremap', function () {

    return {
        restrict: 'EA',
        controller: function ($scope, $element, Coubr) {

            var drop = function (event) {
                $scope.data.latitude = event.latLng.lat();
                $scope.data.longitude = event.latLng.lng();
            };

            var init = function (position) {

                $scope.data.latitude = position.lat;
                $scope.data.longitude = position.lng;

                var mapOptions = {
                    center: position,
                    zoom: 15
                };
                var map = new google.maps.Map($element[0], mapOptions);

                var marker = new google.maps.Marker({
                    icon: {
                        url: 'http://business.coubr.de/static/images/icons/marker-64.png'
                    },
                    draggable: true,
                    animation: google.maps.Animation.DROP,
                    position: position,
                    map: map
                });

                google.maps.event.addListener(marker, 'dragend', drop);

            }

            $scope.$on('success', function (event, success) {

                if (success.data.latitude && success.data.longitude) {
                    var position = { lat: parseFloat(success.data.latitude), lng: parseFloat(success.data.longitude) };
                    init(position);
                }

            });

        }
    }

});

/**********************************************
 **********************************************
 *
 * other
 *
 **********************************************
 *********************************************/

coubrBusiness.controller('DateController', ['$scope', function ($scope) {
    $scope.today = Date.now();
}]);

/**********************************************
 **********************************************
 *
 * Directives
 *
 **********************************************
 *********************************************/


coubrBusiness.directive('cbrerror', function () {

    return {
        restrict: 'EA',
        link: function (scope, element, attrs) {

            var display = element.css('display');

            var text = function (attr, defaultText) {

                if (attrs[attr.toLowerCase()]) {
                    element.html(attrs[attr.toLowerCase()]);
                } else {
                    element.html(defaultText);
                }

            };

            element.css('display', 'none');

            scope.$on('success', function () {
                element.css('display', 'none');
            });

            scope.$on('error', function (event, error) {

                element.css('display', display);

                if (error.status) {

                    if (error.status == 400) {
                        // bad request

                        if (error.data && error.data.code) {

                            switch (error.data.code) {
                                case '40000':
                                    text('userNotLoggedIn', 'Invalid Request. User is not logged in.');
                                    break;
                                case '40001':
                                    text('emailNotFound', 'Invalid Request. Email not found.');
                                    break;
                                case '40002':
                                    text('passwordNotFound', 'Invalid Request. Password not found.');
                                    break;
                                case '40003':
                                    text('codeNotFond', 'Invalid Request. Code not found.');
                                    break;
                                case '40004':
                                    text('notConfirmed', 'Invalid Request. Account not confirmed yet.');
                                    break;
                                case '40005':
                                    text('confirmed', 'Invalid Request. Account already confirmed');
                                    break;
                                case '40006':
                                    text('expired', 'Invalid Request. Code already expired.');
                                    break;
                                case '40007':
                                    text('storeNotFound', 'Invalid Request. Store not found.');
                                    break;
                                case '40008':
                                    text('addressNotFound', 'Invalid Request. Address not found.');
                                    break;
                                case '40009':
                                    text('typeNotFound', 'Invalid Request. Type or category not found.');
                                    break;
                                case '40010':
                                    text('couponNotFound', 'Invalid Request. Coupon not found.');
                                    break;
                                case '40011':
                                    text('invalidAmount', 'Invalid Request. Amount invalid.');
                                    break;
                                case '40099':
                                    text('invalidInput', 'Invalid input format.');
                                    break;
                                default:
                                    text('badRequest', 'Invalid Request. An error occurred');
                                    break;
                            }

                        } else {
                            text('badRequest', 'Invalid Request. An error occurred');
                        }


                    } else if (error.status == 404) {
                        // not found
                        text('notFound', 'An error occurred. <span class="coubr">coubr</span> not reachable.');

                    } else if (error.status == 409) {
                        // conflict
                        if (error.data && error.data.code) {

                            switch (error.data.code) {
                                case '40901':
                                    text('emailFound', 'Conflict. User already registered.');
                                    break;
                                default:
                                    text('conflict', 'Conflict. Please try again.');
                                    break;
                            }
                        } else {
                            text('conflict', 'Conflict. Please try again.');
                        }

                    } else if (error.status == 500) {
                        // internal server error
                        if (error.data && error.data.code) {

                            switch (error.data.code) {
                                case '50001':
                                    text('sendMessageError', 'An internal error occurred. Please try again.');
                                    break;
                                default:
                                    text('internalServerError', 'An internal error occurred. Please try again later.');
                                    break;
                            }
                        } else {
                            text('internalServerError', 'An internal error occurred. Please try again later.');
                        }


                    } else {
                        // other error
                        text('otherError', 'An unknown error occurred. Please try again.');
                    }
                }

            });

        }

    }

});

coubrBusiness.directive('cbrprocess', function () {

    return {
        restrict: 'EA',
        link: function (scope, element) {

            var display = element.css('display');
            element.css('display', 'none');

            scope.$on('processing', function () {
                element.css('display', display);
            });

            scope.$on('success', function () {
                element.css('display', 'none');
            });

            scope.$on('error', function () {
                element.css('display', 'none');
            });

        }
    }
});

coubrBusiness.directive('cbrinputerror', function () {

    return {
        restrict: 'E',
        link: function (scope, element, attrs) {

            var display = element.css('display');
            element.css('display', 'none');


            if (attrs.cbrname) {

                var expression = function () {
                    if (scope.form[attrs.cbrname]) {
                        return (scope.form[attrs.cbrname].$dirty && scope.form[attrs.cbrname].$invalid);
                    }
                };

                var text = function (attr, defaultText) {

                    if (attrs[attr.toLowerCase()]) {
                        element.append("<span>" + attrs[attr.toLowerCase()] + "</span>&nbsp;");
                    } else {
                        element.append("<span>" + defaultText + "</span>&nbsp;");
                    }

                };

                var message = function () {
                    element.empty();

                    if (scope.form[attrs.cbrname] && scope.form[attrs.cbrname].$error) {

                        if (scope.form[attrs.cbrname].$error.required) {
                            text('cbrrequired', 'Empty field.');
                        }

                        if (scope.form[attrs.cbrname].$error.email) {
                            text('cbremail', 'Not a valid email address.');
                        }

                        if (scope.form[attrs.cbrname].$error.url) {
                            text('cbrrequired', 'Not a valid url. Try to put http:// or https:// in the beginning.');
                        }

                        if (scope.form[attrs.cbrname].$error.date) {
                            text('cbrdate', 'Not a valid date format.');
                        }

                        if (scope.form[attrs.cbrname].$error.number) {
                            text('cbrnumber', 'Not a valid number.');
                        }

                        if (scope.form[attrs.cbrname].$error.match) {
                            text('cbrmatch', 'No match.');
                        }

                        if (scope.form[attrs.cbrname].$error.minlength) {
                            text('cbrminlength', 'More characters required.');
                        }

                        if (scope.form[attrs.cbrname].$error.maxlength) {
                            text('cbrmaxlength', 'Less characters required.');
                        }

                        if (scope.form[attrs.cbrname].$error.min) {
                            text('cbrmin', 'Value too low.');
                        }

                        if (scope.form[attrs.cbrname].$error.max) {
                            text('cbrmax', 'Value too high.');
                        }

                    }

                };


                scope.$watch(expression, function (newValue, oldValue) {

                    if (newValue) {
                        element.css('display', display);
                    } else {
                        element.css('display', 'none');
                    }


                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.required', function (newValue, oldValue) {
                    message();
                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.email', function (newValue, oldValue) {
                    message();
                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.url', function (newValue, oldValue) {
                    message();
                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.date', function (newValue, oldValue) {
                    message();
                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.number', function (newValue, oldValue) {
                    message();
                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.match', function (newValue, oldValue) {
                    message();
                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.minlength', function (newValue, oldValue) {
                    message();
                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.maxlength', function (newValue, oldValue) {
                    message();
                });


                scope.$watch('form.' + [attrs.cbrname] + '.$error.min', function (newValue, oldValue) {
                    message();
                });

                scope.$watch('form.' + [attrs.cbrname] + '.$error.max', function (newValue, oldValue) {
                    message();
                });

            }
        }
    }

});

coubrBusiness.directive('match', function () {

    // Copyright
    // https://github.com/TheSharpieOne/angular-input-match/blob/master/README.md

    return {
        require: 'ngModel',
        restrict: 'A',
        scope: {
            match: '='
        },
        link: function (scope, elem, attrs, ctrl) {
            scope.$watch(function () {
                var modelValue = ctrl.$modelValue || ctrl.$$invalidModelValue;
                return (ctrl.$pristine && angular.isUndefined(modelValue)) || scope.match === modelValue;
            }, function (currentValue) {
                ctrl.$setValidity('match', currentValue);
            });
        }
    }

});
