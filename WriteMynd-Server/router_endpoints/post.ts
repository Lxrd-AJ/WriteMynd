import * as Ex from 'express';
import * as Request from 'request';
import * as Q from 'q';

import {IUser, User} from './../models/user';
import {IPost, Post} from './../models/post';
import {IReportedPost, ReportedPost} from './../models/reported_post';
import {ParseConfig} from './../config';

export module PostsHandler {
    const parseEndpoint = `http://localhost:${ParseConfig.port}/parse/classes`;
    let reqOptions = {
        url: parseEndpoint,
        headers: {
            'X-Parse-Application-Id': ParseConfig.appId
        }
    }

    export function getReportedPosts(req: Ex.Request, res: Ex.Response) {
        //User.find().exec().then((users) => console.log(users));
        let options = reqOptions; options.url = parseEndpoint + '/ReportedPost/';
        Request.get(options, (err, resp, body) => {
            if (err) { res.status(500).send(err); }
            else {
                const reportedPosts:JSON[] = JSON.parse(body).results;
                const resultPromises = reportedPosts.map((reportedPost) => {
                    return getPost(reportedPost['postID']).then((post) => {
                        reportedPost['postID'] = post;
                        return reportedPost;
                    });
                }); 
                Q.allSettled(resultPromises).then((states) => {
                    const result = states.map((state) => state.value);
                    res.json(result);
                });
            }
        })
    }

    export function allowReportedPost(req: Ex.Request, res: Ex.Response) {
        const _postID = req.query.postID;
        console.log(`Allow post ID ${_postID}`)
        ReportedPost.findOneAndRemove({ postID: _postID }).exec().then((result) => {
            console.log(result);
            res.status(200).send("Removed");
        }).onReject((err) => {
            console.error(err);
            res.status(500).send("Not removed");
        })
    }

    function getPost(id:string): Q.Promise<JSON> {
        reqOptions.url = parseEndpoint + `/Post/${id}`;
        const defer = Q.defer<JSON>() 
        Request.get(reqOptions, (err, resp, body) => {
            if (err) {
                console.error(err);
                defer.resolve();
            } else {
                const result = JSON.parse(body);
                defer.resolve(result);
            }
        })
        return defer.promise;
    }
}