import * as Ex from 'express';
import * as Fs from 'fs';

import {IUser, User} from './../models/user';
import {BlockedUser,IBlockedUser} from './../models/blocked_user';

export module UserHandler {
    export function blockUser(req: Ex.Request, res: Ex.Response) {
        const id = req.body.userID;
        BlockedUser.update({ userID: id }, { $set: { userID: id } }, { upsert: true }).exec().then((result) => {
            res.status(200).send("Ok");
        })
    }

    /**
     *Checks if a user is blocked in the system
     *  */
    export function isUserBlocked(req: Ex.Request, res: Ex.Response) {
        const id = req.query.userID
        console.log("UserID " + id);
        BlockedUser.findOne({ userID: id }).exec().then((result) => {
            if (result) { res.status(200).json({ "result": true }) }
            else{ res.status(200).json({ "result":false }) }
        })
    }

    /**
     * Returns all users who have email addresses */
    export function getUsersCSV(req: Ex.Request, res: Ex.Response) {
        User.find({ "email": {$exists:true}}).exec().then((users) => {
            const stream = Fs.createWriteStream('data_dir/emails.csv');
            users.forEach((user) => stream.write(`${user.email}\n`))
            stream.end();
            stream.on('finish', () => {
                Fs.createReadStream('data_dir/emails.csv').pipe(res);
            })
        });
    }
}