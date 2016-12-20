import * as Mongoose from 'mongoose';

const BlockedUserSchema = new Mongoose.Schema({
    userID: String
}, {collection: "BlockedUser"})

export interface IBlockedUser extends Mongoose.Document {
    userID: string    
}

export const BlockedUser = Mongoose.model<IBlockedUser>("BlockedUser",BlockedUserSchema)