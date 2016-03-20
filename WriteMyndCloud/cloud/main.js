
//WriteMynd

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.beforeSave("EmpathisedPost", function(request,response){
    var newEntry = request.object;
    var queryPosts = new Parse.Query("EmpathisedPost");
    queryPosts.equalTo("user", newEntry.get("user"));
    queryPosts.equalTo("postID", newEntry.get("postID"));

    queryPosts.first({
        success: function(res){
            response.error("Post already empathised");
        },error: function(err){
            response.success();
        }
    })
})
