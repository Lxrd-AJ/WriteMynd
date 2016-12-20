import { ModuleWithProviders }  from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ReportedPostsComponent } from './reported_post/reported_post.component';

const routes: Routes = [
    { path: '/reported_post', component: ReportedPostsComponent },
    { path: '', redirectTo: '/reported_post', pathMatch: 'full' }, //todo: change to the homepage
    { path: '**', redirectTo: '/reported_post' }
];

export const WriteMyndRouter: ModuleWithProviders = RouterModule.forRoot(routes, { useHash: true });
