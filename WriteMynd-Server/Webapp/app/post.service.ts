import {Injectable} from '@angular/core';
import {Http,Response} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';

@Injectable()
export class PostService {
    constructor(private http: Http) { }
    
    getReportedPosts(): Promise<JSON[]> {
        return this.http.get('/reported_posts')
            .toPromise()
            .then(res => res.json().data as JSON[])
            .catch(this.handleError);
    }

    private handleError(error: any): Promise<any> {
        console.error('An error occurred', error); // for demo purposes only
        return Promise.reject(error.message || error);
    }
}