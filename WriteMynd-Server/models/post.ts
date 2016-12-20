import * as Mongoose from 'mongoose';

const PostSchema = new Mongoose.Schema({
    _p_parent: String,
    private: Boolean,
    emoji: String,
    hashTags: [String],
    text: String,
    reportCount: Number
}, { collection: 'Post' })

export interface IPost extends Mongoose.Document {
    _p_parent: string,
    private: string,
    emoji: string,
    hashTags: string[],
    text: string,
    reportCount: number
}

export const Post = Mongoose.model<IPost>("Post", PostSchema);