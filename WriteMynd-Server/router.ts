import * as Exress from 'express'; 

import {PostsHandler} from './router_endpoints/post'
import {UserHandler} from './router_endpoints/user'

export class Router {
    constructor(private app: Exress.Express) {
        app.route("/reported_posts").get(PostsHandler.getReportedPosts);
        app.route("/block_user").post(UserHandler.blockUser);
        app.route("/is_user_blocked").get(UserHandler.isUserBlocked);
        app.route("/allow_post").post(PostsHandler.allowReportedPost);
        app.route("/user_emails").get(UserHandler.getUsersCSV);
    }    
}