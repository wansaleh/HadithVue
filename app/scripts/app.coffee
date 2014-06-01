'use strict'

# initialize app
@app = angular.module('HadithVue', [
  'ngSanitize'
  # 'ngResource'
  # 'ngRoute'
  'ngAnimate'

  # others
  'ui.router'
  'angular-data.DSCacheFactory'
  'picardy.fontawesome'
  'angular-loading-bar'
  'headroom'
])

# ui-router cofigurations
.config ['$stateProvider', '$urlRouterProvider', '$locationProvider',
($stateProvider, $urlRouterProvider, $locationProvider) ->
  $locationProvider.html5Mode true

  $urlRouterProvider.otherwise '/'

  hadith_views =
    '':
      templateUrl: 'partials/hadith--list'
      controller: 'HadithListController'
    'header':
      templateUrl: 'partials/hadith--header'
      controller: 'CollectionListController'
    'sidebar':
      templateUrl: 'partials/hadith--sidebar'
      controller: 'BookListController'
    'footer':
      templateUrl: 'partials/hadith--footer'
      controller: 'BookListController'

  $stateProvider
    .state 'home',
      url: '/'
      templateUrl: 'partials/home'
      controller: 'CollectionListController'

    .state 'hadith',
      abstract: true
      url: '/hadith'
      templateUrl: 'partials/hadith'
      controller: 'HadithViewController'

    .state 'hadith.bookid',
      url: '/:collection/:book_id'
      views: hadith_views

    .state 'hadith.nobookid',
      url: '/:collection'
      views: hadith_views
]

.config ['cfpLoadingBarProvider',
(cfpLoadingBarProvider) ->
  cfpLoadingBarProvider.includeSpinner = false
]

# vars
.value 'config',
  appName: 'HadithVue'

# run app
.run ['$rootScope', '$http', '$state', '$stateParams', 'DSCacheFactory'
($rootScope, $http, $state, $stateParams, DSCacheFactory) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams

  DSCacheFactory 'ivCache',
    maxAge: 900000
    cacheFlushInterval: 6000000
    deleteOnExpire: 'aggressive'

  $http.defaults.cache = DSCacheFactory.get 'ivCache'
]
