/*
 * coubr-js
 * http://www.coubr.com/labs/coubrJS

 * Version: 0.0.1
 * License: MIT
 */
var coubrJS = angular.module('coubrJS', []);

coubrJS.config(function () {

});

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
            data: JSON.stringify(data, true)
        }).success(function (data, status, headers, config) {
            var success = successHandler(data, status, headers, config);
            $rootScope.$broadcast('success', success);
            deferred.resolve(success);
        }).error(function (data, status, headers, config) {
            var error = errorHandler(data, status, headers, config);
            $rootScope.$broadcast('error', error);
            deferred.reject(error);
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
    var gotoPage = function (url, query) {

        if (query) {
            $location.search(query);
        }

        if (url.indexOf('#') == 0) {
            // location path
            $location.path(url.substring(1, url.length));
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

    var transformUrl = function (url) {

        var data = parseRoute();

        var processedUrl = '';

        var splittedUrl = url.split('/');
        splittedUrl.forEach(function (entry) {
            var part = entry;

            if (entry.indexOf(':') == 0) {

                var variable = entry.substring(1, entry.length);

                part = data[variable];

            }

            processedUrl += part + '/';
        });

        if (url.lastIndexOf('/') != url.length) {
            processedUrl = processedUrl.substring(0, processedUrl.length - 1);
        }

        return processedUrl;

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
        transformUrl: transformUrl
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
        name: 'form',
        replace: true,
        restrict: 'E',
        controller: function ($scope, $element, $attrs, $animate, Coubr) {

            $scope.query = Coubr.parseQuery();
            $scope.route = Coubr.parseRoute();

            $scope.master = {};

            $scope.reset = function () {
                $scope.data = angular.copy($scope.master);
            };

            var form = this,
                invalidCount = 0, // used to easily determine if we are valid
                errors = form.$error = {},
                controls = [];

            form.$name = 'form';
            form.$dirty = false;
            form.$pristine = true;
            form.$valid = true;
            form.$invalid = false;

            $scope.form = form;

            var VALID_CLASS = 'ng-valid',
                INVALID_CLASS = 'ng-invalid',
                PRISTINE_CLASS = 'ng-pristine',
                DIRTY_CLASS = 'ng-dirty';

            // setter
            var cbr = {};

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

                Coubr.get(Coubr.transformUrl(initfrom)).then(function (success) {

                    if (angular.isObject(success.data)) {
                        Object.getOwnPropertyNames(success.data).forEach(function (entry) {
                            $scope.master[entry] = success.data[entry];
                        });
                    }

                    $scope.reset();
                });

            };

            $scope._initfromquery = function () {

                $scope.master = Coubr.parseQuery();
                $scope.reset();

            };

            // Form Controller methods (TODO find a better way to reuse)

            // overwritten functions
            function snakeCase(name, separator) {
                var SNAKE_CASE_REGEXP = /[A-Z]/g;

                separator = separator || '_';
                return name.replace(SNAKE_CASE_REGEXP, function (letter, pos) {
                    return (pos ? separator : '') + letter.toLowerCase();
                });
            }

            function arrayRemove(array, value) {
                var index = array.indexOf(value);
                if (index >= 0)
                    array.splice(index, 1);
                return value;
            }

            // Setup initial state of the control
            $element.addClass(PRISTINE_CLASS);
            toggleValidCss(true);

            function toggleValidCss(isValid, validationErrorKey) {
                validationErrorKey = validationErrorKey ? '-' + snakeCase(validationErrorKey, '-') : '';
                $animate.setClass($element,
                        (isValid ? VALID_CLASS : INVALID_CLASS) + validationErrorKey,
                        (isValid ? INVALID_CLASS : VALID_CLASS) + validationErrorKey);
            }

            form.$addControl = function (control) {
                // Breaking change - before, inputs whose name was "hasOwnProperty" were quietly ignored
                // and not added to the scope.  Now we throw an error.
                //assertNotHasOwnProperty(control.$name, 'input');
                controls.push(control);

                if (control.$name) {
                    form[control.$name] = control;
                }
            };

            form.$removeControl = function (control) {
                if (control.$name && form[control.$name] === control) {
                    delete form[control.$name];
                }
                angular.forEach(errors, function (queue, validationToken) {
                    form.$setValidity(validationToken, true, control);
                });

                arrayRemove(controls, control);
            };

            form.$setValidity = function (validationToken, isValid, control) {
                var queue = errors[validationToken];

                if (isValid) {
                    if (queue) {
                        arrayRemove(queue, control);
                        if (!queue.length) {
                            invalidCount--;
                            if (!invalidCount) {
                                toggleValidCss(isValid);
                                form.$valid = true;
                                form.$invalid = false;
                            }
                            errors[validationToken] = false;
                            toggleValidCss(true, validationToken);
                            //parentForm.$setValidity(validationToken, true, form);
                        }
                    }

                } else {
                    if (!invalidCount) {
                        toggleValidCss(isValid);
                    }
                    if (queue) {
                        if (queue.indexOf(control) != -1) return;
                    } else {
                        errors[validationToken] = queue = [];
                        invalidCount++;
                        toggleValidCss(false, validationToken);
                        //parentForm.$setValidity(validationToken, false, form);
                    }
                    queue.push(control);

                    form.$valid = false;
                    form.$invalid = true;
                }
            };

            form.$setDirty = function () {
                $animate.removeClass($element, PRISTINE_CLASS);
                $animate.addClass($element, DIRTY_CLASS);
                form.$dirty = true;
                form.$pristine = false;
                //parentForm.$setDirty();
            };

            form.$setPristine = function () {
                $animate.removeClass($element, DIRTY_CLASS);
                $animate.addClass($element, PRISTINE_CLASS);
                form.$dirty = false;
                form.$pristine = true;
                angular.forEach(controls, function (control) {
                    control.$setPristine();
                });
            };


            // methods

            $scope.isUnchanged = function () {
                return angular.equals($scope.data, $scope.master);
            };

            $scope.isInvalid = function () {
                return form.$invalid;
            };

            $scope.submit = function () {

                $scope.master = angular.copy($scope.data);

                if (form.$invalid) {
                    return;
                }

                Coubr.post(Coubr.transformUrl(cbr.postto), $scope.data).then(function (success) {

                    if (angular.isObject(success.data)) {
                        Object.getOwnPropertyNames(success.data).forEach(function (entry) {
                            $scope.data[entry] = success.data[entry];
                        });
                    }

                    if (cbr.then) {
                        eval(cbr.then);
                    }

                    if (cbr.thengoto) {
                        var url = cbr.thengoto;
                        var path = url;

                        var processedQuery = {};

                        // query string
                        if (url.indexOf('?') >= 0) {

                            var splittedUrl = url.split('?');
                            path = splittedUrl[0];
                            var query = splittedUrl[1];

                            // parse query
                            var splittedQuery = [query];
                            if (query.indexOf('&') >= 0) {
                                splittedQuery = url.split('&');
                            }

                            splittedQuery.forEach(function (entry) {

                                if (entry.indexOf(':') == 0) {
                                    var entryName = entry.substring(1, entry.length);
                                    processedQuery[entryName] = $scope.data[entryName];
                                } else {
                                    if (entry.indexOf('=') >= 0) {
                                        var splittedPath = entry.split('=');
                                        var variable = splittedPath[0];
                                        processedQuery[variable] = splittedPath[1];
                                    }
                                }
                            });

                        } else {
                            path = url;
                        }

                        // path

                        Coubr.gotoPage(path, processedQuery);
                    }

                });
            };

            $scope.reset();

        },
        link: function (scope, element, attrs) {

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
        restrict: 'E',
        link: function (scope, element, attrs) {


            attrs.$set('ng-disabled', "isInvalid() || isUnchanged()");


            var submitListener = function (event) {

                event.preventDefault ? event.preventDefault() : event.returnValue = false;

                scope.submit();

            };

            if (element[0].addEventListener) {
                element[0].addEventListener('click', submitListener);
            } else {
                element[0].attachEvent('onclick', submitListener);
            }

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

                // todo parse route
                // $scope.data = Coubr.parseRoute();
            };

            $scope._then = function (then) {
                cbr.then = then;
            };

            $scope._bind = function (bind) {
                cbr.bind = bind;
            }


            // methods

            $scope.fetch = function () {

                Coubr.get(Coubr.transformUrl(cbr.getfrom)).then(function (success) {

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

