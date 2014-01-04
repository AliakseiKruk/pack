
pack.controller('ProductsCtrl', function($scope, $http, Data, $window)
{
  var url = '/products';
  $scope.products = {};

  $scope.clear_form = function(){
    $scope.src = {  name:'Name'
                  , width: 0
                  , height: 0
                  , depth: 0
                  , weight: 0
                  , stock_level: 0
                  , id: 0
                  };
  };

  $scope.load = function()
  {
    $scope.message = 'Loading data...';
    $http.get(url).
                  success(function(data, status) {
                    $scope.message = status;
                    for(var i=0; i<data.length; i++)
                    {
                      $scope.products[data[i]['id']] = data[i];
                      if($scope.data.products[data[i]['id']])
                      {
                        $scope.products[data[i]['id']]['order'] = $scope.data.products[data[i]['id']]['order'];
                        $scope.products[data[i]['id']]['checked'] = true;
                        $scope.check_stock($scope.products[data[i]['id']]);
                      }
                      else
                      {
                        $scope.products[data[i]['id']]['order'] = 0;
                        $scope.products[data[i]['id']]['checked'] = false;
                      }
                    }
                  })
                  .
                  error(function(data, status) {
                    $scope.message = status;
                  });
  }

  $scope.add = function()
  {
    $scope.clear_form();
    $scope.form = 1;
  };

  $scope.cancel = function()
  {
    $scope.form = 0;
    $scope.clear_form();
      $scope.productForm.name.$setValidity("rename", true);
  };

  $scope.save = function()
  {
    var path = url;
    var action = 'POST';
    $scope.message = 'Saving...';
    if($scope.src.id > 0)
    {
      path += '/'+$scope.src.id;
      action = 'PUT';
    }
    $http({method: action, url: path, data: $scope.src}).
                  success(function(data, status) {
                    if(data['error'])
                    {
                      $scope.message = data['error'];
                      if(data['error']['name'])
                      {
                        $window.document.forms['productForm'].name.focus();
                        $scope.productForm.name.$setValidity("rename", false);
                        $scope.must_rename=true;
                      }
                    }
                    else
                    {
                      $scope.message = status;
                      if(!$scope.products[data['id']])
                      {
                        $scope.products[data['id']] = {};
                        $scope.products[data['id']]['id'] = data['id'];
                        $scope.products[data['id']]['order'] = 0;
                        $scope.products[data['id']]['checked'] = false;
                      }
                      angular.forEach($scope.src, function(value, key){
                        if(key != 'id')
                        {
                          $scope.products[data['id']][key] = value;
                        }
                      });
                      $scope.form = 0;
                      $scope.clear_form();
                      $scope.check_stock($scope.products[data['id']]);
                    }
                  })
                  .
                  error(function(data, status) {
                    $scope.message = status;
                  });
  };

  $scope.edit = function(product) {
    $scope.src = {  name:        product.name
                  , width:       product.width
                  , height:      product.height
                  , depth:       product.depth
                  , weight:      product.weight
                  , stock_level: product.stock_level
                  , id:          product.id
                  };
    $scope.form = 1;
  };

  $scope.check_stock = function(product)
  {
    if(product.stock_level - product.order < 0)
    {
      product.order = product.stock_level;
    }
    $scope.pack(product);
  }

  $scope.pack = function(product) {
    if(product.checked)
    {
      if(product.order == 0)
      {
        product.order = 1;
      }
      if(!$scope.data.products[product.id])
      {
        $scope.data.products[product.id] = product;
      }
      else
      {
        $scope.data.products[product.id]['order'] = product.order
      }
    }
    else
    {
      product.order = 0;
      if($scope.data.products[product.id])
      {
        delete($scope.data.products[product.id]);
      }
    }
  };

  $scope.delete = function(product)
  {
    var path = url+'/'+product.id;
    var action = 'DELETE';
    $scope.message = 'Deleting...';
    $http({method: action, url: path}).
                  success(function(data, status) {
                    $scope.message = status;
                    delete($scope.data.products[data['id']]);
                    delete($scope.products[data['id']]);
                  })
                  .
                  error(function(data, status) {
                    $scope.message = status;
                  });
  };

  $scope.check_name_options = function() {
    if($scope.must_rename && !$scope.productForm.name.$valid)
    {
      $scope.productForm.name.$setValidity("rename", true);
    }
  }

  $scope.data = Data;
  $scope.form = 0;
  $scope.clear_form();
  $scope.load();

});

