/*
 * coubr-js
 * http://www.coubr.com/labs/coubrJS

 * Version: 0.0.1
 * Copyright 2014. Sebastian Hof
 * License: MIT
 */
define(['angular'], function (angular) {

    var coubrJS = angular.module('coubrJS', []);

    /*
     * Coubr service
     */
    coubrJS.factory('Coubr', ['$http', '$location', '$q', '$rootScope', '$route', '$routeParams', '$window', function ($http, $location, $q, $rootScope, $route, $routeParams, $window) {

        // private

        /*
         * Success handler
         */
        var successHandler = function (data, status, header, config) {
            var success = {};

            success.data = data;
            success.status = status;
            success.header = header;
            success.config = config;

            return success;
        };

        /*
         * Error handler
         */
        var errorHandler = function (data, status, header, config) {
            var error = {};

            error.data = data;
            error.status = status;
            error.header = header;
            error.config = config;

            return error;
        };

        var json = function (method, url, data) {
            $rootScope.$broadcast('processing');

            var deferred = $q.defer();

            $http({
                method: method,
                url: url,
                data: data
            }).success(function (data, status, headers, config) {
                var success = successHandler(data, status, headers, config);
                $rootScope.$broadcast('success', success);
                deferred.resolve(success);
            }).error(function (data, status, headers, config) {
                var error = errorHandler(data, status, headers, config);
                $rootScope.$broadcast('error', error);
                deferred.reject(error);
                //deferred.resolve(error);
            });

            return deferred.promise;
        };

        // $http

        var get = function (url, data) {
            return json('get', url, data);
        };

        var post = function (url, data) {
            return json('post', url, data);
        };

        var put = function (url, data) {
            return json('put', url, data);
        };

        var _delete = function (url, data) {
            return json('delete', url, data);
        };

        // $location
        var gotoPage = function (url, data) {
            url = transformURI(url, data);
            var path = url;
            var query = {};

            if (url.indexOf('?') > 0) {
                var splittedURL = url.split('?');
                path = splittedURL[0];
                var query = splittedURL[1];

                var splittedQuery = [query];
                if (query.indexOf('&') >= 0) {
                    splittedQuery = query.split('&');
                }

                splittedQuery.forEach(function (entry) {
                    var queryPart = entry.split('=');
                    query[queryPart[0]] = queryPart[1] || '';
                });


            }

            if (url.indexOf('#') == 0) {
                // location path
                $location.path(path.substring(1, path.length)).search(query);
            } else {
                // window open
                $window.open(url, '_self');
            }

        };

        var refreshPage = function () {

            $route.refresh();

        };

        /*
         * parse
         */

        var parseQuery = function () {
            var data = {};

            if ($location.$$search) {
                Object.getOwnPropertyNames($location.$$search).forEach(function (entry) {
                    data[entry] = $location.$$search[entry];
                });
            }

            return data;
        };

        var parseRoute = function () {
            var data = {};

            if ($routeParams) {
                Object.getOwnPropertyNames($routeParams).forEach(function (entry) {
                    data[entry] = $routeParams[entry];
                });
            }

            return data;
        };

        var transformURI = function (url, data) {
            var route = parseRoute();

            if (!data) {
                data = route;
            }

            var path = url;
            var processedPath = '';
            var processedQuery = '';

            // process query string
            if (url.indexOf('?') >= 0) {

                var splittedUrl = url.split('?');
                path = splittedUrl[0];
                var query = splittedUrl[1];

                var splittedQuery = [query];
                if (query.indexOf('&') >= 0) {
                    splittedQuery = query.split('&');
                }

                splittedQuery.forEach(function (entry) {
                    var queryPart = entry;

                    if (entry.indexOf(':') == 0) {
                        var variable = entry.substring(1, entry.length);
                        if (data.hasOwnProperty(variable)) {
                            queryPart = variable + '=' + data[variable];
                        } else {
                            queryPart = route[variable];
                        }

                    }

                    processedQuery += queryPart + '&';
                });

                if (processedQuery.lastIndexOf('&') == processedQuery.length - 1) {
                    processedQuery = processedQuery.substring(0, processedQuery.length - 1);
                }

            }

            var splittedPath = path.split('/');
            splittedPath.forEach(function (entry) {
                var part = entry;

                if (entry.indexOf(':') == 0) {
                    var variable = entry.substring(1, entry.length);
                    if (data.hasOwnProperty(variable)) {
                        part = data[variable];
                    } else {
                        part = route[variable];
                    }

                }

                processedPath += part + '/';
            });

            if (processedPath.lastIndexOf('/') == processedPath.length - 1) {
                processedPath = processedPath.substring(0, processedPath.length - 1);
            }

            if (processedQuery != '') {
                return encodeURI(processedPath + '?' + processedQuery);
            } else {
                return encodeURI(processedPath);
            }

            return

        };

        return {

            get: get,
            post: post,
            put: put,
            delete: _delete,
            gotoPage: gotoPage,
            refreshPage: refreshPage,
            parseQuery: parseQuery,
            parseRoute: parseRoute,
            transformURI: transformURI
        }


    }]);

    /**********************************************
     **********************************************
     *
     * Form
     *
     **********************************************
     *********************************************/

    /*
     * Coubr Form
     */
    coubrJS.directive('cbrform', function () {

        return {
            restrict: 'A',
            controller: function ($scope, $element, $attrs, $animate, Coubr) {

                // init scope
                var master = {};

                if ($scope.data) {
                    master = $scope.data;
                }

                $scope.query = Coubr.parseQuery();
                $scope.route = Coubr.parseRoute();

                // init cbr
                var cbr = {};

                // init methods
                $scope.reset = function () {
                    $scope.data = angular.copy(master);
                };

                $scope._postto = function (postto) {
                    cbr.postto = postto;
                };

                $scope._thengoto = function (thengoto) {
                    cbr.thengoto = thengoto;
                };

                $scope._then = function (then) {
                    cbr.then = then;
                };

                $scope._initfrom = function (initfrom) {

                    Coubr.get(Coubr.transformURI(initfrom)).then(function (success) {

                        if (angular.isObject(success.data)) {
                            Object.getOwnPropertyNames(success.data).forEach(function (entry) {
                                master[entry] = success.data[entry];
                            });

                            $scope.reset();
                        }

                    });

                };

                $scope._initfromquery = function () {

                    $scope.data = Coubr.parseQuery();
                    cbr.reset();

                };

                // public methods

                $scope.submit = function () {

                    //$scope.reset();

                    if ($scope.isInvalid()) {
                        return;
                    }

                    if (cbr.postto) {

                        Coubr.post(Coubr.transformURI(cbr.postto), $scope.data).then(function (success) {

                            if (angular.isObject(success.data)) {
                                Object.getOwnPropertyNames(success.data).forEach(function (entry) {
                                    master[entry] = success.data[entry];
                                });

                                $scope.reset();
                            }

                            if (cbr.then) {
                                eval('$scope.' + cbr.then);
                            }

                            if (cbr.thengoto) {
                                Coubr.gotoPage(cbr.thengoto, $scope.data);
                            }

                        });

                    } else {

                        // use default form action
                        form.submit();

                    }

                };

                $scope.isUnchanged = function () {
                    return (angular.equals($scope.data, $scope.master));
                };

                $scope.isInvalid = function () {
                    return $scope.form.$invalid;
                };

                $scope.reset();

            },
            link: function (scope, element, attrs, ctrl) {

                // postto
                if (attrs.postto) {
                    scope._postto(attrs.postto);
                }

                // thengoto
                if (attrs.thengoto) {
                    scope._thengoto(attrs.thengoto);
                }

                // then
                if (attrs.then) {
                    scope._then(attrs.then);
                }

                // initfromquery
                if (attrs.initfromquery) {
                    scope._initfromquery();
                }

                // initfrom
                if (attrs.initfrom) {
                    scope._initfrom(attrs.initfrom);
                }

            }
        }

    });

    coubrJS.directive('cbrsubmit', function () {

        return {
            restrict: 'AE',
            link: function (scope, element, attrs) {

                // submit listener

                var submitListener = function (event) {
                    event.preventDefault ? event.preventDefault() : event.returnValue = false;

                    attrs.$set('disabled', 'disabled');

                    scope.submit();
                };

                if (element[0].addEventListener) {
                    element[0].addEventListener('click', submitListener);
                } else {
                    element[0].attachEvent('onclick', submitListener);
                }

                scope.$on('success', function () {
                    element.removeAttr('disabled');
                });

                scope.$on('error', function () {
                    element.removeAttr('disabled');
                });

                // button status listener

                var buttonStatusListener = function () {

                    if (scope.isInvalid() || scope.isUnchanged()) {
                        attrs.$set('disabled', 'disabled');
                    } else {
                        element.removeAttr('disabled');
                    }


                };

                scope.$watch(scope.isInvalid, buttonStatusListener);
                scope.$watch(scope.isUnchanged, buttonStatusListener);

            }

        }


    });

    /**********************************************
     **********************************************
     *
     * Fetch
     *
     **********************************************
     *********************************************/

    /*
     * Coubr Fetch
     */

    coubrJS.directive('cbrfetch', function () {

        return {
            restrict: 'E',
            controller: function ($scope, $element, $attrs, Coubr) {

                $scope.data = {};
                $scope.query = Coubr.parseQuery();
                $scope.route = Coubr.parseRoute();

                // setter
                var cbr = {};

                $scope._getfrom = function (getfrom) {
                    cbr.getfrom = getfrom;
                };

                $scope._then = function (then) {
                    cbr.then = then;
                };

                $scope._bind = function (bind) {
                    cbr.bind = bind;
                }

                // methods

                $scope.fetch = function () {

                    Coubr.get(Coubr.transformURI(cbr.getfrom)).then(function (success) {

                        if (success.data) {

                            if (angular.isObject(success.data)) {
                                Object.getOwnPropertyNames(success.data).forEach(function (entry) {

                                    if (cbr.bind) {
                                        $scope[cbr.bind][entry] = success.data[entry];
                                    } else {
                                        $scope.data[entry] = success.data[entry];
                                    }

                                });
                            }

                            if (cbr.then) {
                                eval(cbr.then);
                            }

                        }

                    });

                };

            },
            link: function (scope, element, attrs) {

                // getfrom
                if (attrs.getfrom) {
                    scope._getfrom(attrs.getfrom);
                }

                // then
                if (attrs.then) {
                    scope._then(attrs.then);
                }

                // bind
                if (attrs.bind) {
                    scope._bind(attrs.bind);
                }

                scope.fetch();

            }
        }

    });

    /**********************************************
     **********************************************
     *
     * Directives
     *
     **********************************************
     *********************************************/

    coubrJS.directive('cbrerror', function () {

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

    coubrJS.directive('cbrprocess', function () {

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

    coubrJS.directive('cbrinputerror', function () {

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

    coubrJS.directive('match', function () {

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

    return coubrJS;

});
