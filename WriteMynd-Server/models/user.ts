import * as Mongoose from 'mongoose';

const UserSchema = new Mongoose.Schema({
    email: String,
    username: String
}, { collection: '_User' })

export interface IUser extends Mongoose.Document {
    email: string,
    username: string 
}

export const User = Mongoose.model<IUser>("User", UserSchema);