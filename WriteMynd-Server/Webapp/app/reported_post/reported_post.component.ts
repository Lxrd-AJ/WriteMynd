/**
 * - todo:
 *      [ ] Refactor into an app module
 */

import { Component, OnInit } from '@angular/core';
import {Http,Response,Headers,RequestOptions} from '@angular/http';
// import {MD_LIST_DIRECTIVES} from '@angular2-material/list';
// import {MD_CARD_DIRECTIVES} from '@angular2-material/card';
import {PostService} from './../post.service'

@Component({
    selector: "reported-post",
    template: `
        <h1>Reported Posts</h1>
        <div class="row">
            <div class="post-card col-md-6" *ngFor="let rPost of reportedPosts">
                <h2>{{rPost.postID.emoji}}</h2>
                <h3>{{rPost.postID.hashTags}}</h3>
                <p>{{rPost.postID.text}}</p>  
                <small>Report count <span class="badge">{{rPost.postID.reportCount}}</span></small>          
                <div>
                    <button class="btn btn-default" (click)="allowPost(rPost.postID.objectId)">Allow Post</button>
                    <!-- <button class="btn btn-danger">Delete</button> -->
                    <button class="btn btn-danger" (click)="deleteUser(rPost.postID.parent.objectId)">Do not Allow Post</button>
                </div>
            </div>
        </div>
    `,
    styles: [`
        h1,h2,h3,h4 { font-weight: 300; }
        .post-card {
            border: 1px solid rgb(230,230,230);
        }
    `]
})
export class ReportedPostsComponent implements OnInit{
    reportedPosts: JSON[] = []
    headers = new Headers({
            'Content-Type': 'application/json'
        });
    options = new RequestOptions({ headers: this.headers });

    constructor(private postService: PostService, private http: Http) { }

    ngOnInit() { 
        this.postService.getReportedPosts().then((posts) => {
            this.reportedPosts = posts;
        })
    }

    //todo: Migrate to a service    
    deleteUser(userID: string) {
        //console.log(userID);
        this.http.post('/block_user', JSON.stringify({ userID: userID }), this.options).subscribe(
            res => { console.log(res); }
        )
    }

    //todo: Migrate to a service    
    allowPost(postID: string) {
        console.log(postID);
        this.http.post(`/allow_post?postID=${postID}`, "", this.options).subscribe(
            res => {
                console.log(res);
                this.reportedPosts = this.reportedPosts.filter((post) => post["postID"]["objectId"] !== postID)
            }
        )
    }
}