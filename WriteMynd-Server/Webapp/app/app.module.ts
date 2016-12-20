/* angular imports */
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpModule } from '@angular/http';

/* App Imports */
import { WriteMyndRouter } from './app.routing';
import { AppComponent } from './app.component';
import { NavigationComponent } from './navigation/navigation.component';
import { ReportedPostsComponent } from './reported_post/reported_post.component';
import { PostService } from './post.service';

@NgModule({
    imports: [BrowserModule, WriteMyndRouter, HttpModule ],
    declarations: [AppComponent,NavigationComponent,ReportedPostsComponent],
    bootstrap: [AppComponent],
    providers: [PostService]
})
export class AppModule{}
