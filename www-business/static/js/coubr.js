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
            $scope.reset = function() {
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
