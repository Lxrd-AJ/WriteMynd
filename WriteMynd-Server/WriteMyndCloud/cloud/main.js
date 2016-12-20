
//WriteMynd

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.beforeSave("EmpathisedPost", function(request,response){
    var newEntry = request.object;
    var queryPosts = new Parse.Query("EmpathisedPost");
    queryPosts.equalTo("userID", newEntry.get("userID"));
    queryPosts.equalTo("postID", newEntry.get("postID"));

    queryPosts.first({
        success: function(res){
            if (res) {
                response.error("Post already empathised");
            } else {
                response.success();
            }
        },error: function(err){
            response.success();
        }
    })
})
