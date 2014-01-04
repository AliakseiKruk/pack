
pack.controller('BoxesCtrl', function($scope, $http, Data, $window)
{
  var url = '/boxes';
  $scope.boxes = {};

  $scope.clear_form = function(){
    $scope.src = {  name:'Name'
                  , volume: 0
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
                      $scope.boxes[data[i]['id']] = data[i];
                      if($scope.data.box['id'] == data[i]['id'])
                      {
                        $scope.boxes[data[i]['id']]['checked'] = true;
                      }
                      else
                      {
                        $scope.boxes[data[i]['id']]['checked'] = false;
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
    $scope.boxForm.name.$setValidity("rename", true);
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
                        $window.document.forms['boxForm'].name.focus();
                        $scope.boxForm.name.$setValidity("rename", false);
                        $scope.must_rename=true;
                      }
                    }
                    else
                    {
                      $scope.message = status;
                      if(!$scope.boxes[data['id']])
                      {
                        $scope.boxes[data['id']] = {};
                        $scope.boxes[data['id']]['id'] = data['id'];
                        $scope.boxes[data['id']]['checked'] = false;
                      }
                      angular.forEach($scope.src, function(value, key){
                        if(key != 'id')
                        {
                          $scope.boxes[data['id']][key] = value;
                        }
                      });
                      $scope.form = 0;
                      $scope.clear_form();
                    }
                  })
                  .
                  error(function(data, status) {
                    $scope.message = status;
                  });
  };

  $scope.edit = function(box) {
    $scope.src = {  name:   box.name
                  , volume: box.volume
                  , id:     box.id
                  };
    $scope.form = 1;
  };

  $scope.pack = function(box) {
    if(box.checked)
    {
      $scope.data.box = box;
      angular.forEach($scope.boxes, function(value, key){
        if(value['id'] != box.id)
        {
          value['checked'] = false;
        }
      });
    }
    else
    {
      $scope.data.box = {};
    }
  };

  $scope.delete = function(box)
  {
    var path = url+'/'+box.id;
    var action = 'DELETE';
    $scope.message = 'Deleting...';
    $http({method: action, url: path}).
                  success(function(data, status) {
                    $scope.message = status;
                    if(box == $scope.data.box)
                    {
                      $scope.data.box = {};
                    }
                    delete($scope.boxes[data['id']]);
                  })
                  .
                  error(function(data, status) {
                    $scope.message = status;
                  });
  };

  $scope.check_name_options = function() {
    if($scope.must_rename && !$scope.boxForm.name.$valid)
    {
      $scope.boxForm.name.$setValidity("rename", true);
    }
  }

  $scope.data = Data;
  $scope.form = 0;
  $scope.clear_form();
  $scope.load();

});

