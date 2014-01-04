
pack.controller('PacksCtrl', function($scope, $http, Data)
{
  var url = '/packs';
  $scope.data = Data;

  $scope.pack = function() {
    var path = url;
    var action = 'POST';
    var products = [];

    if($scope.data.box['id'])
    {
      products.push($scope.data.box['id']);
      angular.forEach($scope.data.products, function(value, key){
        if(value['order'] > 0)
        {
          products.push({'id':value['id'], 'order':value['order']});
        }
      });
    }
    if(products.length > 1)
    {
      $scope.message = 'Calculating...';
      $http({method: action, url: path, data:{'todo':products}}).
                    success(function(data, status) {
                      $scope.message = status;
                      if(data['error'])
                      {
                        $scope.message = data['error'];
                        $scope.boxes = false;
                      }
                      else
                      {
                        if(data['boxes'].length > 0)
                        {
                          $scope.boxes = [];
                          for(var i=0; i<data['boxes'].length; i++)
                          {
                            products = [];
                            for( var j=0; j<data['boxes'][i]['box'].length; j++ )
                            {
                              products.push({ 'name':$scope.data.products[data['boxes'][i]['box'][j]['id']]['name'], 'qnt':data['boxes'][i]['box'][j]['qnt'] });
                            }
                            $scope.boxes.push({ 'num':(i+1), 'full':data['boxes'][i]['full'], 'products':products });
                          }
                        }
                        else
                        {
                          $scope.boxes = false;
                        }
                      }
                    })
                    .
                    error(function(data, status) {
                      $scope.message = status;
                    });
    }
  };

});

