import * as Mongoose from 'mongoose';

import {IUser} from './user';
import {IPost} from './post';

const ReportedPostSchema = new Mongoose.Schema({
    postID: String,
    reporterID: String
}, { collection: 'ReportedPost' });

export interface IReportedPost extends Mongoose.Document {
    postID: IPost,
    reporterID: IUser
}

export const ReportedPost = Mongoose.model<IReportedPost>("ReportedPost", ReportedPostSchema);